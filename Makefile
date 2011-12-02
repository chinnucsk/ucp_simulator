ERL		?= erl
ERLC		= erlc
EBIN_DIRS	:= $(wildcard deps/*/ebin)
APPS		:= $(shell ls apps)
REL_DIR     	= rel
NODE		= {{name}}
REL		= {{name}}
SCRIPT_PATH  	:= $(REL_DIR)/$(NODE)/bin/$(REL)

.PHONY: rel deps

all: deps compile

compile: deps
	@rebar compile -j 1

deps:
	@rebar get-deps
	@rebar check-deps

clean:
	@rebar clean

realclean: clean
	@rebar delete-deps

test:
	@rebar skip_deps=true ct

rel: deps
	@rebar compile generate

start: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) start

stop: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) stop

ping: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) ping

attach: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) attach

console: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) console

restart: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) restart

reboot: $(SCRIPT_PATH)
	@./$(SCRIPT_PATH) reboot

doc:
	rebar skip_deps=true doc
	for app in $(APPS); do \
		cp -R apps/$${app}/doc doc/$${app}; \
	done;

initenv:
	rebar get-deps
	rebar clean compile
	rebar doc

run:
	rebar clean compile
	@erl -pa ebin -s ucp_simulator_app start
	#@erl -pa ebin -boot start_sasl -s ucp_simulator_app start

analyze: checkplt
	@rebar skip_deps=true dialyze

buildplt:
	@rebar skip_deps=true build-plt

checkplt: buildplt
	@rebar skip_deps=true check-plt
