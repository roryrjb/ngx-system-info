#include <ngx_config.h>
#include <ngx_core.h>
#include <ngx_http.h>
#include <sys/sysinfo.h>

#define JSON "{\n\
  \"uptime\": %d,\n\
  \"totalram\": %l,\n\
  \"freeram\": %l,\n\
  \"loadavg\": [\n\
    %2.2f, %2.2f, %2.2f\n\
  ],\n\
  \"sharedram\": %l,\n\
  \"bufferram\": %l,\n\
  \"totalswap\": %l,\n\
  \"freeswap\": %l,\n\
  \"procs\": %d\n\
}\n"

static char *ngx_http_system_info(ngx_conf_t *cf, ngx_command_t *cmd, void *conf);

static ngx_command_t ngx_http_system_info_commands[] = {
  {
    ngx_string("system_info"),
    NGX_HTTP_LOC_CONF | NGX_CONF_NOARGS,
    ngx_http_system_info,
    0,
    0,
    NULL
  },

  ngx_null_command
};

static ngx_http_module_t ngx_http_system_info_module_ctx = {
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL
};

ngx_module_t ngx_http_system_info_module = {
  NGX_MODULE_V1,
  &ngx_http_system_info_module_ctx,
  ngx_http_system_info_commands,
  NGX_HTTP_MODULE,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NGX_MODULE_V1_PADDING
};

static ngx_int_t ngx_http_system_info_handler(ngx_http_request_t *r) {
  ngx_buf_t *b;
  ngx_chain_t out;

  r->headers_out.status = NGX_HTTP_OK;
  r->headers_out.content_type.len = sizeof("application/json") - 1;
  r->headers_out.content_type.data = (u_char *) "application/json";

  struct sysinfo si;
  sysinfo(&si);

  char output[] = JSON;

  float load1 = si.loads[0] / 65536.0;
  float load5 = si.loads[1] / 65536.0;
  float load15 = si.loads[2] / 65536.0;

  size_t size = sizeof(output) + sizeof(si.uptime) + sizeof(si.totalram) +
    sizeof(si.freeram) + sizeof(load1) + sizeof(load5) + sizeof(load15) +
    sizeof(si.sharedram) + sizeof(si.bufferram) + sizeof(si.totalswap) +
    sizeof(si.freeswap) + sizeof(si.procs);

  b = ngx_create_temp_buf(r->pool, size);

  if (b == NULL) {
    return NGX_HTTP_INTERNAL_SERVER_ERROR;
  }

  out.buf = b;
  out.next = NULL;

  b->last = ngx_sprintf(b->last, output,
    si.uptime,
    si.totalram,
    si.freeram,
    load1,
    load5,
    load15,
    si.sharedram,
    si.bufferram,
    si.totalswap,
    si.freeswap,
    si.procs
  );

  b->memory = 1;
  b->last_buf = 1;

  r->headers_out.content_length_n = b->last - b->pos;
  ngx_http_send_header(r);

  return ngx_http_output_filter(r, &out);
}

static char *ngx_http_system_info(ngx_conf_t *cf, ngx_command_t *cmd, void *conf) {
  ngx_http_core_loc_conf_t *clcf;

  clcf = ngx_http_conf_get_module_loc_conf(cf, ngx_http_core_module);
  clcf->handler = ngx_http_system_info_handler;

  return NGX_CONF_OK;
}
