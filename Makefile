all: client.byte
serve: bx.gdb
	gs_routeserver $< handlers.yaml
clean:
	ocamlbuild -clean
%.byte:
	ocamlbuild -use-ocamlfind $@


#FIXME Makefile.config and targets to get a token, update, etc.

bx.gdb: stib.gtfsdb
	gs_new $@
	gs_import_gtfs $@ $<

stib.gtfsdb: stib.zip
	gs_gtfsdb_compile $@ $<

#gs_osmdb_compile bx.osm{,db}
#gs_import_osm bx.gdb bx.osmdb
#gs_link_osm_gtfs bx.gdb bx.osmdb stib.gtfsdb
