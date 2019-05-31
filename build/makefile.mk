# Entrypoint for applications and libraries Makefiles
# Required variables:
#   TEAM_NAME
#   APP_NAME
#   APP_PORT
#
# Optional variables:
#   LIBRARY  (default: FALSE)
#
# Available command by default are defined in common_dev.mk and ci.mk files
# If the service is executable, LIBRARY variable is set to false, commands from
# app_dev.mk and cd.mk are added.

SELF_DIR=$(dir $(lastword $(MAKEFILE_LIST)))
APP_ROOT=.

include $(SELF_DIR)/common_dev.mk
include $(SELF_DIR)/ci.mk

ifneq ($(LIBRARY),true)
  include $(SELF_DIR)/app_dev.mk
  include $(SELF_DIR)/cd.mk
endif
