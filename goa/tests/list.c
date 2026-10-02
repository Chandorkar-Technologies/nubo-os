#define GOA_API_IS_SUBJECT_TO_CHANGE
#define GOA_BACKEND_API_IS_SUBJECT_TO_CHANGE
#include <gtk/gtk.h>
#include <goa/goa.h>
#include <goabackend/goabackend.h>

static void cb (GObject *o, GAsyncResult *r, gpointer d)
{
  GList *l = NULL, *i; GError *e = NULL;
  if (!goa_provider_get_all_finish (&l, r, &e)) { g_printerr ("err %s\n", e->message); exit (1); }
  int n = 0;
  for (i = l; i; i = i->next, n++)
    {
      GoaProvider *p = i->data;
      char *name = goa_provider_get_provider_name (p, NULL);
      GIcon *icon = goa_provider_get_provider_icon (p, NULL);
      char *is = g_icon_to_string (icon);
      g_print ("%d: type=%-10s name=%-32s group=%d features=0x%x icon=%s\n", n,
               goa_provider_get_provider_type (p), name, goa_provider_get_provider_group (p),
               goa_provider_get_provider_features (p), is);
    }
  exit (0);
}
int main (void)
{
  gtk_init_check ();
  goa_provider_get_all (cb, NULL);
  g_main_loop_run (g_main_loop_new (NULL, FALSE));
}
