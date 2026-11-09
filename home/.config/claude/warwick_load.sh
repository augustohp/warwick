# Use IPv4 for Claude Code on networks where its IPv6 connection resets.
# Loaded automatically by the Warwick shell configuration.
claude() {
    BUN_FEATURE_FLAG_DISABLE_IPV6=1 command claude "$@"
}
