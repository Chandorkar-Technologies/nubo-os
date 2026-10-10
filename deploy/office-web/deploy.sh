#!/usr/bin/env bash
# Deploy Nubo Office on the web to the k3s cluster (needs kubectl access). Safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"
BRAND=../../office/brand
kubectl apply -f - <<< 'apiVersion: v1
kind: Namespace
metadata: { name: nubo-office-web }'
kubectl -n nubo-office-web create configmap nubo-office-wopi-app --from-file=wopi.py --dry-run=client -o yaml | kubectl apply -f -
kubectl -n nubo-office-web create configmap nubo-office-brand --from-file="$BRAND/branding.css" --from-file="$BRAND/branding.js" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n nubo-office-web create configmap nubo-office-brand-images --from-file="$BRAND/images" --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f manifest.yaml
# After a change to wopi.py or the brand pack, restart so the pods pick it up:
kubectl -n nubo-office-web rollout restart deploy/nubo-office-wopi deploy/nubo-office-cool >/dev/null
kubectl -n nubo-office-web rollout status deploy/nubo-office-wopi --timeout=120s
kubectl -n nubo-office-web rollout status deploy/nubo-office-cool --timeout=300s
