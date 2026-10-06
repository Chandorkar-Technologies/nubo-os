#!/usr/bin/env bash
# Turn one qcow2 disk into every other virtual-disk format.
# Usage: convert.sh QCOW2 OUT_DIR FLAVOUR VERSION ARCH
# Makes: raw.xz (AWS, DigitalOcean, Linode, bare metal), vmdk (VMware),
#   ova (VMware, VirtualBox), vhdx (Hyper-V), vhd (Azure, fixed), vdi (VirtualBox),
#   gcp.tar.gz (Google Compute Engine). The qcow2 itself serves KVM, Proxmox,
#   OpenStack, UTM and Incus.
# Needs qemu-utils and xz-utils.
set -euo pipefail
SRC="$(readlink -f "${1:?qcow2}")"; OUT="$(readlink -f "${2:?out dir}")"
FLAVOUR="${3:?flavour}"; VER="${4:?version}"; ARCH="${5:?arch}"
N="nubo-os-${FLAVOUR}-${VER}-${ARCH}"
TMP="$(mktemp -d)"; trap 'rm -rf "${TMP}"' EXIT
mkdir -p "${OUT}"
SIZE="$(qemu-img info --output=json "${SRC}" | sed -n 's/.*"virtual-size": *\([0-9]*\).*/\1/p')"

qemu-img convert -O raw "${SRC}" "${TMP}/disk.raw"
xz -T0 -k -c "${TMP}/disk.raw" >"${OUT}/${N}.raw.xz"

# Google wants a tar of exactly disk.raw, in GNU sparse format.
tar --format=oldgnu -Sczf "${OUT}/${N}.gcp.tar.gz" -C "${TMP}" disk.raw
rm -f "${TMP}/disk.raw"

qemu-img convert -O vmdk -o subformat=streamOptimized "${SRC}" "${OUT}/${N}.vmdk"
qemu-img convert -O vhdx "${SRC}" "${OUT}/${N}.vhdx"
qemu-img convert -O vdi "${SRC}" "${OUT}/${N}.vdi"
# Azure needs a fixed disk whose size is a whole number of MiB.
qemu-img convert -O vpc -o subformat=fixed,force_size "${SRC}" "${OUT}/${N}.vhd"

# OVA: an OVF description plus the stream-optimized vmdk.
case "${ARCH}" in amd64) OSTYPE=ubuntu64Guest ;; *) OSTYPE=arm-ubuntu64Guest ;; esac
cp "${OUT}/${N}.vmdk" "${TMP}/${N}-disk1.vmdk"
VMDK_BYTES="$(stat -c %s "${TMP}/${N}-disk1.vmdk")"
cat >"${TMP}/${N}.ovf" <<OVF
<?xml version="1.0" encoding="UTF-8"?>
<Envelope xmlns="http://schemas.dmtf.org/ovf/envelope/1" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" xmlns:rasd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_ResourceAllocationSettingData" xmlns:vssd="http://schemas.dmtf.org/wbem/wscim/1/cim-schema/2/CIM_VirtualSystemSettingData" xmlns:vmw="http://www.vmware.com/schema/ovf">
  <References><File ovf:id="file1" ovf:href="${N}-disk1.vmdk" ovf:size="${VMDK_BYTES}"/></References>
  <DiskSection><Info>Virtual disks</Info>
    <Disk ovf:diskId="vmdisk1" ovf:fileRef="file1" ovf:capacity="${SIZE}" ovf:capacityAllocationUnits="byte" ovf:format="http://www.vmware.com/interfaces/specifications/vmdk.html#streamOptimized"/>
  </DiskSection>
  <NetworkSection><Info>Networks</Info><Network ovf:name="VM Network"><Description>VM Network</Description></Network></NetworkSection>
  <VirtualSystem ovf:id="${N}">
    <Info>Nubo OS ${FLAVOUR} ${VER}</Info><Name>${N}</Name>
    <OperatingSystemSection ovf:id="94" vmw:osType="${OSTYPE}"><Info>Ubuntu based</Info></OperatingSystemSection>
    <VirtualHardwareSection><Info>Virtual hardware</Info>
      <System><vssd:ElementName>Virtual Hardware Family</vssd:ElementName><vssd:InstanceID>0</vssd:InstanceID><vssd:VirtualSystemIdentifier>${N}</vssd:VirtualSystemIdentifier><vssd:VirtualSystemType>vmx-13</vssd:VirtualSystemType></System>
      <Item><rasd:AllocationUnits>hertz * 10^6</rasd:AllocationUnits><rasd:Description>CPU</rasd:Description><rasd:ElementName>2 CPUs</rasd:ElementName><rasd:InstanceID>1</rasd:InstanceID><rasd:ResourceType>3</rasd:ResourceType><rasd:VirtualQuantity>2</rasd:VirtualQuantity></Item>
      <Item><rasd:AllocationUnits>byte * 2^20</rasd:AllocationUnits><rasd:Description>Memory</rasd:Description><rasd:ElementName>4096 MB</rasd:ElementName><rasd:InstanceID>2</rasd:InstanceID><rasd:ResourceType>4</rasd:ResourceType><rasd:VirtualQuantity>4096</rasd:VirtualQuantity></Item>
      <Item><rasd:Address>0</rasd:Address><rasd:Description>SCSI controller</rasd:Description><rasd:ElementName>SCSI</rasd:ElementName><rasd:InstanceID>3</rasd:InstanceID><rasd:ResourceSubType>VirtualSCSI</rasd:ResourceSubType><rasd:ResourceType>6</rasd:ResourceType></Item>
      <Item><rasd:AddressOnParent>0</rasd:AddressOnParent><rasd:ElementName>Hard disk 1</rasd:ElementName><rasd:HostResource>ovf:/disk/vmdisk1</rasd:HostResource><rasd:InstanceID>4</rasd:InstanceID><rasd:Parent>3</rasd:Parent><rasd:ResourceType>17</rasd:ResourceType></Item>
      <Item><rasd:AutomaticAllocation>true</rasd:AutomaticAllocation><rasd:Connection>VM Network</rasd:Connection><rasd:ElementName>Network</rasd:ElementName><rasd:InstanceID>5</rasd:InstanceID><rasd:ResourceSubType>VmxNet3</rasd:ResourceSubType><rasd:ResourceType>10</rasd:ResourceType></Item>
      <vmw:Config ovf:required="false" vmw:key="firmware" vmw:value="efi"/>
    </VirtualHardwareSection>
  </VirtualSystem>
</Envelope>
OVF
tar --format=ustar -C "${TMP}" -cf "${OUT}/${N}.ova" "${N}.ovf" "${N}-disk1.vmdk"
ls -lh "${OUT}/${N}".*
