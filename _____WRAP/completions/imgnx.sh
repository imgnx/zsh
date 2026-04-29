#compdef myapp

# Example Zsh completion file demonstrating various completion patterns

_myapp() {
  local context state state_descr line
  typeset -A opt_args

  _arguments -C \
    '1: :_myapp_commands' \
    '*::arg:->args' \
    '(-h --help)'{-h,--help}'[Show help]' \
    '(-v --verbose)'{-v,--verbose}'[Enable verbose output]' \
    '--config[Config file]:file:_files'

  case $state in
    args)
      case $words[1] in
        
        # File operations with path completion
        (create|edit|delete)
          _arguments \
            '--force[Force operation]' \
            '--backup[Create backup]' \
            '*:file:_files'
          ;;
          
        # Network operations with host completion
        (connect|ping|ssh)
          _arguments \
            '--port[Port number]:port:(22 80 443 8080)' \
            '--timeout[Timeout in seconds]:seconds:' \
            '1:hostname:_hosts'
          ;;
          
        # Process management with PID completion
        (kill|suspend|resume)
          _arguments \
            '(-9 --force)'{-9,--force}'[Force kill]' \
            '*:process:_pids'
          ;;
          
        # User management with user completion
        (adduser|deluser|usermod)
          _arguments \
            '--home[Home directory]:directory:_directories' \
            '--shell[Login shell]:shell:_files -W /bin' \
            '1:username:_users'
          ;;
          
        # Package management example
        (install|remove|update)
          local -a packages
          packages=(
            'nginx:Web server'
            'mysql:Database server' 
            'redis:In-memory data store'
            'docker:Container platform'
            'git:Version control'
            'vim:Text editor'
            'tmux:Terminal multiplexer'
          )
          _arguments \
            '--yes[Assume yes to prompts]' \
            '--dry-run[Show what would be done]' \
            '*:package:_describe "packages" packages'
          ;;
          
        # Configuration with multiple value types
        (config|set)
          _arguments \
            '--global[Set global config]' \
            '--local[Set local config]' \
            '1:key:(debug.level server.port database.host api.key)' \
            '2:value:_myapp_config_values'
          ;;
          
        # Log operations with date completion
        (logs|tail)
          _arguments \
            '--follow[Follow log output]' \
            '--lines[Number of lines]:count:' \
            '--since[Show logs since]:date:_dates' \
            '--level[Log level]:level:(debug info warn error fatal)' \
            '1:logfile:_files -g "*.log"'
          ;;
          
        # Service management
        (start|stop|restart|status)
          local -a services
          services=($(systemctl list-units --type=service --no-legend 2>/dev/null | awk '{print $1}' | sed 's/\.service$//' | head -20))
          _arguments \
            '--now[Execute immediately]' \
            '--force[Force operation]' \
            '*:service:_describe "services" services'
          ;;
          
        # Git-like operations
        (commit|push|pull)
          _arguments \
            '--message[Commit message]:message:' \
            '--branch[Target branch]:branch:_git_branch_names' \
            '--remote[Remote name]:remote:(origin upstream)' \
            '*:file:_files'
          ;;
          
        # Archive operations
        (compress|extract)
          _arguments \
            '--format[Archive format]:format:(tar zip 7z gz bz2)' \
            '--output[Output file]:file:_files' \
            '*:input:_files'
          ;;
      esac
      ;;
  esac
}

# Helper function for main commands
_myapp_commands() {
  local -a commands
  commands=(
    'create:Create new files or resources'
    'edit:Edit existing files'
    'delete:Delete files or resources'
    'connect:Connect to remote host'
    'ping:Ping network host'
    'ssh:SSH to remote host'
    'kill:Terminate processes'
    'suspend:Suspend processes'
    'resume:Resume processes'
    'adduser:Add new user'
    'deluser:Delete user'
    'usermod:Modify user'
    'install:Install packages'
    'remove:Remove packages'
    'update:Update packages'
    'config:Configure settings'
    'set:Set configuration values'
    'logs:View log files'
    'tail:Follow log files'
    'start:Start services'
    'stop:Stop services'
    'restart:Restart services'
    'status:Check service status'
    'commit:Commit changes'
    'push:Push to remote'
    'pull:Pull from remote'
    'compress:Create archives'
    'extract:Extract archives'
  )
  _describe -t commands 'myapp commands' commands
}

# Helper function for config values based on key
_myapp_config_values() {
  case $words[CURRENT-1] in
    debug.level)
      _values 'debug level' 'trace' 'debug' 'info' 'warn' 'error'
      ;;
    server.port)
      _message 'port number (1-65535)'
      ;;
    database.host)
      _hosts
      ;;
    api.key)
      _message 'API key string'
      ;;
    *)
      _message 'configuration value'
      ;;
  esac
}

_myapp "$@"
