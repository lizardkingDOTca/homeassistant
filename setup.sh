# Generate a random 20-character password (alphanumeric + symbols)
PASS=$(tr -dc 'A-Za-z0-9!@#$%^&*()-_=+' </dev/urandom | head -c 20)

# Create group with same name as user
USER=homeassistant
sudo synogroup --add "$USER" "$USER group for service account"

# Create user, assign to group, disable login, remove default access
sudo synouser --add "$USER" "$PASS" "Service Account $USER" 0 "" "Used for automation" \
&& sudo synogroup --member "$USER" "$USER" \
&& sudo synouser --setpwpolicy "$USER" 0 0 0 0 0 0 \
&& sudo synosetkeyvalue /usr/syno/etc/packages/DSM/disabled_users "$USER" yes \
&& sudo synoacltool -del-user "$USER" /volume1

# Output generated password securely
echo "User: $USER"
echo "Password: $PASS"
