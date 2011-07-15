default:
	tar czvf puppet.tgz *.pp modules

clean:
	rm puppet.tgz
