if [ -f '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/path.zsh.inc'; fi
# if [ -f '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc' ]; then . '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'; fi

bmad-update-all() {
	bmad-update \
		~/.dotfiles \
		~/Documents/commercial/snyk-ls \
		~/Documents/commercial/go-application-framework \
		~/Documents/commercial/analytics-service \
		~/Documents/commercial/cli \
		~/Documents/commercial/snyk-intellij-plugin \
		~/Documents/commercial/vscode-extension \
		~/Documents/commercial/ldx-sync \
		~/Documents/commercial/code-client-go \
		~/Documents/commercial/snyk-eclipse-plugin \
		~/Documents/commercial/snyk-visual-studio-plugin \
		"$@"
}

# ZSCALER CERTIFICATE CONFIGURATION START
# Added by zscaler-cert-fix-minimal.sh on Wed May 20 11:11:58 CEST 2026
# This section can be safely removed by running the rollback script
export AWS_CA_BUNDLE=~/zscaler-ca-bundle.pem
export REQUESTS_CA_BUNDLE=~/zscaler-ca-bundle.pem
export NODE_EXTRA_CA_CERTS=~/zscaler-ca-bundle.pem
export HOMEBREW_SSL_CERT_FILE=~/zscaler-ca-bundle.pem
export CURL_CA_BUNDLE=~/zscaler-ca-bundle.pem
export SSL_CERT_FILE=~/zscaler-ca-bundle.pem
export WGET_CA_BUNDLE=~/zscaler-ca-bundle.pem
export CACERTS_PATH=~/zscaler-ca-bundle.pem
# ZSCALER CERTIFICATE CONFIGURATION END
