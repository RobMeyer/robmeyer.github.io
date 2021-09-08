IF NOT EXIST ".config_env.bat" (
	ECHO ".config_env.bat does not exist. Copy the following lines into a new file, replacing the secret values with those obtained from www.pinata.cloud"
	ECHO ""
	ECHO "set IPFS_DEPLOY_PINATA__API_KEY=<api key>"
	ECHO "set IPFS_DEPLOY_PINATA__SECRET_API_KEY=<secret api key>"
) ELSE (
	".config_env.bat" && npx ipfs-deploy public -p pinata
)
