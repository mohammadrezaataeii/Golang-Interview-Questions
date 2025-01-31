# Makefile for Git operations

# Default target
all: help

# Help target to display instructions
help:
	@echo "Usage:"
	@echo "  make push MESSAGE=\"Your commit message\" - Commit and push changes to the remote repository"

# Target to add, commit, and push changes
push:
	@if [ -z "$(MESSAGE)" ]; then \
		echo "Error: Commit message not provided! Use MESSAGE=\"Your commit message\""; \
		exit 1; \
	fi
	git add .
	git commit -m "$(MESSAGE)"
	git push
