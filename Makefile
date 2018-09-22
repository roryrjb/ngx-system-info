test:
	shellcheck *.bash
	docker build -t roryrjb/ngx-system-info .
	docker run -it --rm ngx-system-info

.PHONY: test
