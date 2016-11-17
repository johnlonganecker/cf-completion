#!/bin/bash

_exists()
{
  # take array check words for it
  for word in $1
  do
    if [[ $word == $2 ]]; then
      return 0
    fi
  done
  return 1
}

# takes in an array of words $1 removed $2 from it and echos the result
#_word_intersection()
#{
# local return_array=()
# for word in $1
# do
#   if [[ $(_exists $word) -ne 0 ]]; then
#     return return_array+=("$word")
#   fi
# done
# echo "${return_array[*]}
#}

_find_cf_login_api_history()
{
  local prev=""
  local urls=()

  results=$( history | grep "cf login.*-a" )
  word_array=( $results )
  for word in "${word_array[@]}"
  do
    if [[ "$prev" == "-a" ]]; then
      urls+=( $word )
    fi
    prev=$word
  done

  echo "${urls[*]}"
}

_get_orgs()
{
  echo "$(cf orgs | awk 'NR>3' | tr '\n' ' ')"
}

_get_spaces()
{
  echo "$(cf spaces | awk 'NR>3' | tr '\n' ' ')"
}

_get_apps()
{
  echo "app"
}

_get_plugins()
{
  echo "$(cf plugins | awk 'NR>4' | awk '{print $1}' | tr '\n' ' ')"
}

# $1 take in list string space delimited words
# $2 take in current word
_compgen()
{
  COMPREPLY=( $(compgen -W "$1" -- "$2") )
}

_app()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  if [[ "$cur" == -* ]]; then
    _compgen "--guid" $cur
    return 0
  fi

  # autocomplete with orgs from cf command
  if [[ "$prev" == "app" || "$prev"  ]]; then
    _compgen "$(cf apps | awk 'NR>3' | tr '\n' ' ')" $cur
    # COMPREPLY=( $(compgen -W "$(cf apps | awk 'NR>3' | tr '\n' ' ')" -- $cur) )
    return 0
  fi
}

_apps()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  _compgen "--help" $cur
  return 0;
}

_org()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  # already specified a specific org, autocomplete for the --guid flag
  if [[ "$cur" == -* ]]; then
    _compgen "--guid" $cur
    return 0
  fi

  # autocomplete with orgs from cf command
  if [[ "$prev" != "org" ]]; then
    _compgen "$(_get_orgs)" $cur
    return 0
  fi
}

_target()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  all_flags="-o -s"

  if [[ "$prev" == -o ]]; then
    _compgen "$(_get_orgs)" $cur
    return 0
  elif [[ "$prev" == -s ]]; then
    _compgen "$(_get_spaces)" $cur
    return 0
  else
    # check for -o and -s
    if [[ $(_exists ${COMP_WORDS[*]} "-o") -ne 0 ]]; then
      _compgen "-s" $cur
      return 0
    elif [[ $(_exists ${COMP_WORDS[*]}" -s") -ne 0 ]]; then
      _compgen "-o" $cur
      return 0
    else
      _compgen "-o -s" $cur
      return 0
    fi
    return 0
  fi
}

_login() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  #if [[ "$prev" == -a ]]; then
    #_compgen "$(_find_cf_login_api_history)" "$cur"
    #return 0
  #else
    _compgen "--skip-ssl-validation -a -u -p -o -s --sso --help" $cur
    return 0
  #fi
}

_cf()
{
  COMP_WORDBREAKS="\"'@><=;|&("
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}
  local line=${COMP_LINE}

  case ${COMP_WORDS[1]} in
# GETTING STARTED #############################################################
    login)
      _login
      return 0
      ;;
    logout|passwd|orgs)
      _compgen "--help"
      return 0
      ;;
    target)
      _target
      return 0
      ;;
    api)
      _compgen "--help" $cur
      return 0
      ;;
    auth)
      _compgen "--unset --skip-ssl-validation" $cur
      return 0
      ;;
    app)
      _app
      return 0
      ;;

# APPS ########################################################################
    apps)
      _apps
      return 0
      ;;
    push)
      _compgen "--help" $cur
      return 0
      ;;
    scale)
      _compgen "--help" $cur
      return 0
      ;;
    delete)
      _compgen "--help" $cur
      return 0
      ;;
    rename)
      _compgen "--help" $cur
      return 0
      ;;
    start)
      _compgen "--help" $cur
      return 0
      ;;
    stop)
      _compgen "--help" $cur
      return 0
      ;;
    restart)
      _compgen "--help" $cur
      return 0
      ;;
    restage)
      _compgen "--help" $cur
      return 0
      ;;
    restart-app-instance)
      _compgen "--help" $cur
      return 0
      ;;
    events)
      _compgen "--help" $cur
      return 0
      ;;
    files)
      _compgen "--help" $cur
      return 0
      ;;
    logs)
      _compgen "--help" $cur
      return 0
      ;;
    env)
      _compgen "--help" $cur
      return 0
      ;;
    set-env)
      _compgen "--help" $cur
      return 0
      ;;
    unset-env)
      _compgen "--help" $cur
      return 0
      ;;
    stack)
      _compgen "--help" $cur
      return 0
      ;;
    stacks)
      _compgen "--help" $cur
      return 0
      ;;
    copy-source)
      _compgen "--help" $cur
      return 0
      ;;
    create-app-manifest)
      _compgen "--help" $cur
      return 0
      ;;
    get-health-check)
      _compgen "--help" $cur
      return 0
      ;;
    set-health-check)
      _compgen "--help" $cur
      return 0
      ;;
    enable-ssh)
      _compgen "--help" $cur
      return 0
      ;;
    disable-ssh)
      _compgen "--help" $cur
      return 0
      ;;
    ssh-enabled)
      _compgen "--help" $cur
      return 0
      ;;
    ssh)
      _compgen "--help" $cur
      return 0
      ;;

# SERVICES ####################################################################
    marketplace)
      _compgen "--help" $cur
      return 0
      ;;
    services)
      _compgen "--help" $cur
      return 0
      ;;
    service)
      _compgen "--help" $cur
      return 0
      ;;
    create-service)
      _compgen "--help" $cur
      return 0
      ;;
    update-service)
      _compgen "--help" $cur
      return 0
      ;;
    delete-service)
      _compgen "--help" $cur
      return 0
      ;;
    rename-service)
      _compgen "--help" $cur
      return 0
      ;;
    create-service-key)
      _compgen "--help" $cur
      return 0
      ;;
    service-keys)
      _compgen "--help" $cur
      return 0
      ;;
    service-key)
      _compgen "--help" $cur
      return 0
      ;;
    delete-service-key)
      _compgen "--help" $cur
      return 0
      ;;
    bind-service)
      _compgen "--help" $cur
      return 0
      ;;
    unbind-service)
      _compgen "--help" $cur
      return 0
      ;;
    create-user-provided-service)
      _compgen "--help" $cur
      return 0
      ;;
    update-user-provided-service)
      _compgen "--help" $cur
      return 0
      ;;

# ORGS ########################################################################
    org)
      _org
      return 0
      ;;
    org-users)
      _compgen "$(_get_orgs)" $cur
      return 0
      ;;
    create-org)
      _compgen "--help" $cur
      return 0
      ;;
    delete-org)
      _compgen "--help" $cur
      return 0
      ;;
    rename-org)
      _compgen "--help" $cur
      return 0
      ;;

# SPACES ######################################################################
    spaces)
      _compgen "--help" $cur
      return 0
      ;;
    space)
      _compgen "--help" $cur
      return 0
      ;;
    create-space)
      _compgen "--help" $cur
      return 0
      ;;
    delete-space)
      _compgen "--help" $cur
      return 0
      ;;
    rename-org)
      _compgen "--help" $cur
      return 0
      ;;
    allow-space-ssh)
      _compgen "--help" $cur
      return 0
      ;;
    disallow-space-ssh)
      _compgen "--help" $cur
      return 0
      ;;
    space-ssh-allowed)
      _compgen "--help" $cur
      return 0
      ;;

# DOMAINS #####################################################################
    domains)
      _compgen "--help" $cur
      return 0
      ;;
    create-domain)
      _compgen "--help" $cur
      return 0
      ;;
    delete-domain)
      _compgen "--help" $cur
      return 0
      ;;
    create-shared-domain)
      _compgen "--help" $cur
      return 0
      ;;
    delete-shared-domain)
      _compgen "--help" $cur
      return 0
      ;;

# ROUTES ######################################################################
    routes)
      _compgen "--help" $cur
      return 0
      ;;
    create-route)
      _compgen "--help" $cur
      return 0
      ;;
    check-route)
      _compgen "--help" $cur
      return 0
      ;;
    map-route)
      _compgen "--help" $cur
      return 0
      ;;
    unmap-route)
      _compgen "--help" $cur
      return 0
      ;;
    delete-route)
      _compgen "--help" $cur
      return 0
      ;;
    delete-orphaned-routes)
      _compgen "--help" $cur
      return 0
      ;;

# ROUTER GROUPS ###############################################################
    router-groups)
      _compgen "--help" $cur
      return 0
      ;;

# BUILDPACKS ##################################################################
    create-user)
      _compgen "--help" $cur
      return 0
      ;;
    delete-user)
      _compgen "--help" $cur
      return 0
      ;;
    org-users)
      _compgen "--help" $cur
      return 0
      ;;
    set-org-role)
      _compgen "--help" $cur
      return 0
      ;;
    unset-org-role)
      _compgen "--help" $cur
      return 0
      ;;
    space-users)
      _compgen "--help" $cur
      return 0
      ;;
    set-space-role)
      _compgen "--help" $cur
      return 0
      ;;
    unset-space-role)
      _compgen "--help" $cur
      return 0
      ;;

# USER ADMIN ##################################################################
    create-user)
      _compgen "--help" $cur
      return 0
      ;;
    delete-user)
      _compgen "--help" $cur
      return 0
      ;;
    org-users)
      _compgen "--help" $cur
      return 0
      ;;
    set-org-role)
      _compgen "--help" $cur
      return 0
      ;;
    unset-org-role)
      _compgen "--help" $cur
      return 0
      ;;
    space-users)
      _compgen "--help" $cur
      return 0
      ;;
    set-space-role)
      _compgen "--help" $cur
      return 0
      ;;
    unset-space-role)
      _compgen "--help" $cur
      return 0
      ;;

# ORG ADMIN ###################################################################
    quotas)
      _compgen "--help" $cur
      return 0
      ;;
    quota)
      _compgen "--help" $cur
      return 0
      ;;
    set-quota)
      _compgen "--help" $cur
      return 0
      ;;
    create-quota)
      _compgen "--help" $cur
      return 0
      ;;
    delete-quota)
      _compgen "--help" $cur
      return 0
      ;;
    update-quota)
      _compgen "--help" $cur
      return 0
      ;;
    share-private-domain)
      _compgen "--help" $cur
      return 0
      ;;
    unshare-private-domain)
      _compgen "--help" $cur
      return 0
      ;;

# SPACE ADMIN #################################################################
    space-quotas)
      _compgen "" $cur
      return 0
      ;;
    space-quota)
      _compgen "" $cur
      return 0
      ;;
    create-space-quota)
      _compgen "" $cur
      return 0
      ;;
    update-space-quota)
      _compgen "" $cur
      return 0
      ;;
    delete-space-quota)
      _compgen "" $cur
      return 0
      ;;
    set-space-quota)
      _compgen "" $cur
      return 0
      ;;
    unset-space-quota)
      _compgen "" $cur
      return 0
      ;;

# SERVICE ADMIN ###############################################################
    service-auth-tokens)
      _compgen "" $cur
      return 0
      ;;
    create-service-auth-token)
      _compgen "" $cur
      return 0
      ;;
    update-service-auth-token)
      _compgen "" $cur
      return 0
      ;;
    delete-service-auth-token)
      _compgen "" $cur
      return 0
      ;;
    service-brokers)
      _compgen "" $cur
      return 0
      ;;
    create-service-broker)
      _compgen "" $cur
      return 0
      ;;
    update-service-broker)
      _compgen "" $cur
      return 0
      ;;
    delete-service-broker)
      _compgen "" $cur
      return 0
      ;;
    rename-service-broker)
      _compgen "" $cur
      return 0
      ;;
    migrate-service-instances)
      _compgen "" $cur
      return 0
      ;;
    purge-service-offering)
      _compgen "" $cur
      return 0
      ;;
    purge-service-instance)
      _compgen "" $cur
      return 0
      ;;
    service-access)
      _compgen "" $cur
      return 0
      ;;
    enable-service-access)
      _compgen "" $cur
      return 0
      ;;
    disable-service-access)
      _compgen "" $cur
      return 0
      ;;

# SECURITY GROUP ##############################################################
    security-group)
      _compgen "" $cur
      return 0
      ;;
    security-groups)
      _compgen "" $cur
      return 0
      ;;
    create-security-group)
      _compgen "" $cur
      return 0
      ;;
    update-security-group)
      _compgen "" $cur
      return 0
      ;;
    delete-security-group)
      _compgen "" $cur
      return 0
      ;;
    bind-security-group)
      _compgen "" $cur
      return 0
      ;;
    unbind-security-group)
      _compgen "" $cur
      return 0
      ;;
    bind-staging-security-group)
      _compgen "" $cur
      return 0
      ;;
    staging-security-groups)
      _compgen "" $cur
      return 0
      ;;
    unbind-staging-security-group)
      _compgen "" $cur
      return 0
      ;;
    bind-running-security-group)
      _compgen "" $cur
      return 0
      ;;
    running-security-groups)
      _compgen "" $cur
      return 0
      ;;
    unbind-running-security-group)
      _compgen "" $cur
      return 0
      ;;

# ENVIRONMENT VARIABLE GROUPS #################################################
    running-environment-variable-group)
      _compgen "" $cur
      return 0
      ;;
    staging-environment-variable-group)
      _compgen "" $cur
      return 0
      ;;
    set-staging-environment-variable-group)
      _compgen "" $cur
      return 0
      ;;
    set-running-environment-variable-group)
      _compgen "" $cur
      return 0
      ;;

# FEATURE FLAGS ###############################################################
    feature-flags)
      _compgen "" $cur
      return 0
      ;;
    feature-flag)
      _compgen "" $cur
      return 0
      ;;
    enable-feature-flag)
      _compgen "" $cur
      return 0
      ;;
    disable-feature-flag)
      _compgen "" $cur
      return 0
      ;;

# ADVANCED ####################################################################
    curl)
      _compgen "" $cur
      return 0
      ;;
    config)
      _compgen "" $cur
      return 0
      ;;
    oauth-token)
      _compgen "" $cur
      return 0
      ;;
    ssh-code)
      _compgen "" $cur
      return 0
      ;;

# ADD/REMOVE PLUGIN REPOSITORY ################################################
    add-plugin-repo)
      _compgen "" $cur
      return 0
      ;;
    remove-plugin-repo)
      _compgen "" $cur
      return 0
      ;;
    list-plugin-repos)
      _compgen "" $cur
      return 0
      ;;
    repo-plugins)
      _compgen "" $cur
      return 0
      ;;


# ADD/REMOVE PLUGIN ###########################################################
    plugins)
      _compgen "$(_get_plugins)" $cur
      return 0
      ;;
    install-plugin)
      _compgen "" $cur
      return 0
      ;;
    uninstall-plugin)
      _compgen "" $cur
      return 0
      ;;

# INSTALLED PLUGIN COMMANDS ###################################################
    dev)
      _compgen "start stop suspend resume destroy status import target trust untrust version" $cur
      return 0
      ;;

# ENVIRONMENT VARIABLES #######################################################
  #CF_COLOR=false
  #CF_HOME=path/to/dir/
  #CF_PLUGIN_HOME=path/to/dir/
  #CF_STAGING_TIMEOUT=15
  #CF_STARTUP_TIMEOUT=5
  #CF_TRACE=true
  #CF_TRACE=path/to/trace.log
  #HTTP_PROXY=proxy.example.com:8080
# GLOBAL FLAGS ################################################################
  #--version, -v
  #--build, -b
  #--help, -h
  esac
























  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "help login logout passwd target api auth apps app push scale delete rename start stop restart restage restart-app-instance events files logs env set-env unset-env stacks stack copy-source create-app-manifest get-health-check set-health-check enable-ssh disable-ssh ssh-enabled ssh marketplace services service create-service update-service delete-service rename-service create-service-key service-keys service-key delete-service-key bind-service unbind-service create-user-provided-service update-user-provided-service orgs org create-org delete-org rename-org spaces space create-space delete-space rename-space allow-space-ssh disallow-space-ssh space-ssh-allowed domains create-domain delete-domain create-shared-domain delete-shared-domain routes create-route check-route map-route unmap-route delete-route delete-orphaned-routes router-groups buildpacks create-buildpack update-buildpack rename-buildpack delete-buildpack create-user delete-user org-users set-org-role unset-org-role space-users set-space-role unset-space-role quotas quota set-quota create-quota delete-quota update-quota share-private-domain unshare-private-domain space-quotas space-quota create-space-quota update-space-quota delete-space-quota set-space-quota unset-space-quota service-auth-tokens create-service-auth-token update-service-auth-token delete-service-auth-token service-brokers create-service-broker update-service-broker delete-service-broker rename-service-broker migrate-service-instances purge-service-offering purge-service-instance service-access enable-service-access disable-service-access security-group security-groups create-security-group update-security-group delete-security-group bind-security-group unbind-security-group bind-staging-security-group staging-security-groups unbind-staging-security-group bind-running-security-group running-security-groups unbind-running-security-group running-environment-variable-group staging-environment-variable-group set-staging-environment-variable-group set-running-environment-variable-group feature-flags feature-flag enable-feature-flag disable-feature-flag curl config oauth-token ssh-code add-plugin-repo remove-plugin-repo list-plugin-repos repo-plugins plugins install-plugin uninstall-plugin dev --version -v --build -b --help -h" -- $cur) )
  fi
}
complete -F _cf cf
