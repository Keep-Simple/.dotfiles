if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi
# if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi

# ZSCALER CERTIFICATE CONFIGURATION START
# Added by zscaler-cert-fix-minimal.sh on Wed May 20 11:11:58 CEST 2026
# This section can be safely removed by running the rollback script
# The bundle is not in this repo and exists only on the work Mac. Exporting
# these on a machine without it points curl, node, python and the rest at a
# missing CA file, which breaks every https request.
if [ -f ~/zscaler-ca-bundle.pem ]; then
  export AWS_CA_BUNDLE=~/zscaler-ca-bundle.pem
  export REQUESTS_CA_BUNDLE=~/zscaler-ca-bundle.pem
  export NODE_EXTRA_CA_CERTS=~/zscaler-ca-bundle.pem
  export HOMEBREW_SSL_CERT_FILE=~/zscaler-ca-bundle.pem
  export CURL_CA_BUNDLE=~/zscaler-ca-bundle.pem
  export SSL_CERT_FILE=~/zscaler-ca-bundle.pem
  export WGET_CA_BUNDLE=~/zscaler-ca-bundle.pem
  export CACERTS_PATH=~/zscaler-ca-bundle.pem
fi
# ZSCALER CERTIFICATE CONFIGURATION END
