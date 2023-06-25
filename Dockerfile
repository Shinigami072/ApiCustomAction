FROM redocly/cli:latest

COPY handle-args.sh /handle-args.sh

ENTRYPOINT ["/handle-args.sh"]
