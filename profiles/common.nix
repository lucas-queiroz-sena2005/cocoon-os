# Shared locale and time — applies system-wide so shells (including noctalia) see standard env.
{ ... }:
{
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
}
