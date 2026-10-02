/* Test driver: runs the real Nubo add-account dialog (under Broadway), fills in
 * the email address and password, presses the default button and reports what
 * happened. Usage: drive EMAIL PASSWORD [expect-fail] */
#define GOA_API_IS_SUBJECT_TO_CHANGE
#define GOA_BACKEND_API_IS_SUBJECT_TO_CHANGE
#include <gtk/gtk.h>
#include <adwaita.h>
#include <goa/goa.h>
#include <goabackend/goabackend.h>
#include <goabackend/goaproviderdialog.h>

static GoaClient *client;
static GoaProvider *provider;
static const char *email, *password;
static gboolean expect_fail;
static int stage;
static GoaProviderDialog *dlg;
static GMainLoop *loop;

static void collect (GtkWidget *w, GPtrArray *rows, GPtrArray *banners)
{
  if (ADW_IS_ENTRY_ROW (w))
    g_ptr_array_add (rows, w);
  if (ADW_IS_BANNER (w))
    g_ptr_array_add (banners, w);
  for (GtkWidget *c = gtk_widget_get_first_child (w); c; c = gtk_widget_get_next_sibling (c))
    collect (c, rows, banners);
}

static void scan (GPtrArray *rows, GPtrArray *banners)
{
  GListModel *tl = gtk_window_get_toplevels ();
  for (guint i = 0; i < g_list_model_get_n_items (tl); i++)
    {
      GtkWidget *w = g_list_model_get_item (tl, i);
      collect (w, rows, banners);
      g_object_unref (w);
    }
}

static void report_object (GoaObject *obj)
{
  GoaAccount *a = goa_object_peek_account (obj);
  g_print ("ACCOUNT id=%s provider=%s identity=%s presentation=%s attention=%d\n",
           goa_account_get_id (a), goa_account_get_provider_type (a), goa_account_get_identity (a),
           goa_account_get_presentation_identity (a), goa_account_get_attention_needed (a));
  g_print ("IFACES mail=%d calendar=%d contacts=%d files=%d password_based=%d\n",
           goa_object_peek_mail (obj) != NULL, goa_object_peek_calendar (obj) != NULL,
           goa_object_peek_contacts (obj) != NULL, goa_object_peek_files (obj) != NULL,
           goa_object_peek_password_based (obj) != NULL);
  g_print ("DISABLED mail=%d calendar=%d contacts=%d files=%d\n",
           goa_account_get_mail_disabled (a), goa_account_get_calendar_disabled (a),
           goa_account_get_contacts_disabled (a), goa_account_get_files_disabled (a));
  GoaMail *m = goa_object_peek_mail (obj);
  if (m)
    g_print ("MAIL addr=%s name='%s' imap=%s user=%s ssl=%d tls=%d | smtp=%s user=%s auth=%d plain=%d ssl=%d tls=%d\n",
             goa_mail_get_email_address (m), goa_mail_get_name (m), goa_mail_get_imap_host (m),
             goa_mail_get_imap_user_name (m), goa_mail_get_imap_use_ssl (m), goa_mail_get_imap_use_tls (m),
             goa_mail_get_smtp_host (m), goa_mail_get_smtp_user_name (m), goa_mail_get_smtp_use_auth (m),
             goa_mail_get_smtp_auth_plain (m), goa_mail_get_smtp_use_ssl (m), goa_mail_get_smtp_use_tls (m));
  GoaCalendar *c = goa_object_peek_calendar (obj);
  if (c) g_print ("CALENDAR uri=%s\n", goa_calendar_get_uri (c));
  GoaContacts *k = goa_object_peek_contacts (obj);
  if (k) g_print ("CONTACTS uri=%s\n", goa_contacts_get_uri (k));
  GoaFiles *f = goa_object_peek_files (obj);
  if (f) g_print ("FILES uri=%s\n", goa_files_get_uri (f));
  GoaPasswordBased *pb = goa_object_peek_password_based (obj);
  if (pb)
    {
      const char *ids[] = { "password", "imap-password", "smtp-password" };
      for (int i = 0; i < 3; i++)
        {
          char *pw = NULL; GError *e = NULL;
          if (goa_password_based_call_get_password_sync (pb, ids[i], &pw, NULL, &e))
            g_print ("GETPASSWORD %s -> %s\n", ids[i], g_strcmp0 (pw, password) == 0 ? "matches" : "DIFFERS");
          else
            g_print ("GETPASSWORD %s -> error %s\n", ids[i], e->message);
        }
    }
}

static void pump (int ms)
{
  gint64 end = g_get_monotonic_time () + ms * 1000;
  while (g_get_monotonic_time () < end)
    g_main_context_iteration (NULL, FALSE), g_usleep (2000);
}

static void toggle_tests (GoaObject *obj)
{
  GoaAccount *a = goa_object_peek_account (obj);
  const char *props[] = { "mail-disabled", "calendar-disabled", "contacts-disabled", "files-disabled" };
  for (int i = 0; i < 4; i++)
    {
      g_object_set (a, props[i], TRUE, NULL);
      pump (1200);
      g_print ("TOGGLE off %-18s -> ifaces mail=%d cal=%d card=%d files=%d\n", props[i],
               goa_object_peek_mail (obj) != NULL, goa_object_peek_calendar (obj) != NULL,
               goa_object_peek_contacts (obj) != NULL, goa_object_peek_files (obj) != NULL);
      g_object_set (a, props[i], FALSE, NULL);
      pump (1200);
      g_print ("TOGGLE on  %-18s -> ifaces mail=%d cal=%d card=%d files=%d\n", props[i],
               goa_object_peek_mail (obj) != NULL, goa_object_peek_calendar (obj) != NULL,
               goa_object_peek_contacts (obj) != NULL, goa_object_peek_files (obj) != NULL);
    }
}

static void add_cb (GObject *src, GAsyncResult *res, gpointer d)
{
  GError *e = NULL;
  GoaObject *obj = goa_provider_add_account_finish (GOA_PROVIDER (src), res, &e);
  if (obj == NULL)
    {
      g_print ("ADD FAILED: %s (domain %s code %d)\n", e->message, g_quark_to_string (e->domain), e->code);
      exit (expect_fail ? 0 : 2);
    }
  g_print ("ADD OK\n");
  pump (800);
  report_object (obj);
  toggle_tests (obj);
  GError *err = NULL;
  gboolean ok = goa_account_call_ensure_credentials_sync (goa_object_peek_account (obj), NULL, NULL, &err);
  g_print ("ENSURE_CREDENTIALS (correct password) -> %s\n", ok ? "ok" : err->message);
  g_clear_error (&err);
  if (g_getenv ("FLIP"))
    {
      g_file_set_contents ("/tmp/goatest/password", "server-changed-it", -1, NULL);
      g_print ("server password changed\n");
    }
  ok = goa_account_call_ensure_credentials_sync (goa_object_peek_account (obj), NULL, NULL, &err);
  g_print ("ENSURE_CREDENTIALS -> %s%s\n", ok ? "ok" : "error: ", ok ? "" : err->message);
  if (!ok) g_print ("   code=%d attention=%d\n", err->code, goa_account_get_attention_needed (goa_object_peek_account (obj)));
  exit (0);
}

static gboolean tick (gpointer data)
{
  GPtrArray *rows = g_ptr_array_new (), *banners = g_ptr_array_new ();
  scan (rows, banners);
  if (stage == 1 && rows->len >= 2)
    {
      GtkWidget *e0 = g_ptr_array_index (rows, 0), *e1 = g_ptr_array_index (rows, 1);
      dlg = GOA_PROVIDER_DIALOG (gtk_widget_get_ancestor (e0, ADW_TYPE_DIALOG));
      g_object_add_weak_pointer (G_OBJECT (dlg), (gpointer *) &dlg);
      g_print ("DIALOG up: %d entry rows, state=%d\n", rows->len, goa_provider_dialog_get_state (dlg));
      gtk_editable_set_text (GTK_EDITABLE (e0), email);
      gtk_editable_set_text (GTK_EDITABLE (e1), password);
      g_print ("after typing: state=%d (1 = READY)\n", goa_provider_dialog_get_state (dlg));
      GtkWidget *def = adw_dialog_get_default_widget (ADW_DIALOG (dlg));
      g_print ("default widget: %s\n", def ? G_OBJECT_TYPE_NAME (def) : "none");
      if (def) gtk_widget_activate (def);
      stage = 2;
      g_print ("after activate: state=%d (2 = BUSY)\n", goa_provider_dialog_get_state (dlg));
    }
  else if (stage == 2 && dlg != NULL && goa_provider_dialog_get_state (dlg) == GOA_DIALOG_ERROR)
    {
      for (guint i = 0; i < banners->len; i++)
        {
          AdwBanner *b = g_ptr_array_index (banners, i);
          if (gtk_widget_get_mapped (GTK_WIDGET (b)))
            g_print ("BANNER (revealed=%d): %s\n", adw_banner_get_revealed (b), adw_banner_get_title (b));
        }
      g_print ("DIALOG ERROR STATE reached\n");
      exit (expect_fail ? 0 : 3);
    }
  g_ptr_array_free (rows, TRUE); g_ptr_array_free (banners, TRUE);
  return G_SOURCE_CONTINUE;
}

int main (int argc, char **argv)
{
  adw_init ();
  email = argv[1]; password = argv[2]; expect_fail = argc > 3;
  GError *e = NULL;
  client = goa_client_new_sync (NULL, &e);
  if (!client) { g_printerr ("client: %s\n", e->message); return 1; }
  provider = goa_provider_get_for_provider_type ("nubo");
  g_print ("provider: %s (%s)\n", goa_provider_get_provider_type (provider), goa_provider_get_provider_name (provider, NULL));
  goa_provider_add_account (provider, client, NULL, NULL, add_cb, NULL);
  stage = 1;
  g_timeout_add (250, tick, NULL);
  g_timeout_add_seconds (45, (GSourceFunc) exit, GINT_TO_POINTER (9));
  loop = g_main_loop_new (NULL, FALSE);
  g_main_loop_run (loop);
}
