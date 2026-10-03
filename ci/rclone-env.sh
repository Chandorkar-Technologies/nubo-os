# Shared by the CI scripts: rclone remote "r2" from environment variables.
export RCLONE_CONFIG_R2_TYPE=s3
export RCLONE_CONFIG_R2_PROVIDER=Cloudflare
export RCLONE_CONFIG_R2_ACCESS_KEY_ID="${R2_ACCESS_KEY_ID:?}"
export RCLONE_CONFIG_R2_SECRET_ACCESS_KEY="${R2_SECRET_ACCESS_KEY:?}"
export RCLONE_CONFIG_R2_ENDPOINT="${R2_ENDPOINT:?}"
export R2_BUCKET="${R2_BUCKET:-nubo-archive}"
export RCLONE_CONFIG_R2_NO_CHECK_BUCKET=true
