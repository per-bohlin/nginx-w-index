DOCKER_COMPOSE.bin := docker-compose
DOCKER_COMPOSE.args :=
DOCKER_COMPOSE.cmd := $(DOCKER_COMPOSE.bin) $(DOCKER_COMPOSE.args)

static: static-docker-compose

static-docker-compose: env-file
	$(Q)cd "$(ROOT.dir)" && find "$(ROOT.dir)" \
		-type f \
		-name 'docker-compose*.yml' \
		| xargs --no-run-if-empty -I {} \
			$(DOCKER_COMPOSE.cmd) -f "{}" \
			--env-file "$(ROOT.dir)/.env" \
			config -q
