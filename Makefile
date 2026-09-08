# Coding agent harness — operator entry points used by Cursor stop/edit hooks.
# Fill in real recipes when PRODUCT.md / stack.mdc define a product toolchain.

.PHONY: help help-check lint fmt-file lint-file dev-build test test-agent-stop

help:
	@printf '%s\n' \
		'make help          – list targets' \
		'make lint          – repo lint (no-op until product toolchain exists)' \
		'make fmt-file      – format one file (hook; FILE=… or file=…)' \
		'make lint-file     – lint one file (hook; FILE=… or file=…)' \
		'make dev-build     – rebuild local runtime (no-op until Compose exists)' \
		'make test          – run test suite (no-op until tests exist; accepts parallel=true)' \
		'make test-agent-stop – agent unit-only stop gate (no-op until tests exist)' \
		'make help-check    – verify help text is non-empty'

help-check:
	@$(MAKE) -s help | grep -q 'make lint'

lint:
	@echo "make lint: no product lint configured yet (see PRODUCT.md / stack.mdc); OK"

# Hooks pass file=<path>; accept FILE= as well.
fmt-file:
	@echo "make fmt-file: no formatter configured for $${file:-$${FILE:-<unset>}}; OK"

lint-file:
	@echo "make lint-file: no file linter configured for $${file:-$${FILE:-<unset>}}; OK"

dev-build:
	@echo "make dev-build: no Compose/dev-build script configured yet; OK"

test:
	@echo "make test: no test suite configured yet (parallel=$${parallel:-false}); OK"

test-agent-stop:
	@echo "make test-agent-stop: no agent unit suite configured yet; OK"
