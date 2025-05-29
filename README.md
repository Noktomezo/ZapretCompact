<div align="center">
	<img src="assets/thumbnail.svg" alt="thumbnail"/>
	<p>Компактная версия <a href="https://github.com/bol-van/zapret-win-bundle">zapret-win-bundle</a> от <a href="https://github.com/bol-van">bol-van</a></p>
</div>

## 🔥 Фичи
🍃&nbsp; Оставлены только необходимые бинарники<br>
🧹&nbsp; Автоматическая остановка сервиса `WinDivert` при закрытии программы и/или остановке сервиса<br>
💾&nbsp; Установка/удаление сервиса с помощью [nssm](https://nssm.cc/) для обработки непреднамеренных крашей и распределения ресурсов процессора<br>
⛑️&nbsp; Работает точечно по заблокированным доменам/сайтам (а не только YouTube и Discord) для предотвращения поломок TLS (например в Firefox)

## 🧩 Установка
1) [Скачать](https://github.com/Noktomezo/ZapretCompact/archive/refs/heads/main.zip) и распаковать в нужное место (главное не в защищенные папки типа `C:\System32` или `C:\Program Files`)<br>
2) Запустить `start.cmd`<br>
2.1) Для автоматического запуска при входе в систему - запустить `service-install.cmd`<br>
2.2) Для отключения автоматического запуска при входе систему - запустить `service-remove.cmd`

или склонировать c помощью [Git](https://git-scm.com/downloads):
```bash
git clone --depth=1 https://github.com/Noktomezo/ZapretCompact.git
```

## ⚠️ Важно
При использовании программы занимается "слот" VPN, по этому все VPN клиенты будут работать только в режиме "Прокси" или "Системный прокси". Так же некоторые античиты могут ругаться на программу из-за компонента `WinDivert` (например RICOCHET в сериях игр Call Of Duty будет просто закрывать игру без ошибки), так, что при появлении каких либо "странностей" при использовании системы/запуске игр первым делом отключайте данную программу.

## 🧐 Дополнительно
В дополнении к обходу DPI можно так же вернуть доступ к некоторым доменам/ресурсам, которые блокируются "с той стороны" без использования сторонних приложений и VPN, настроив DNS от Comss по [инструкции](https://www.comss.ru/page.php?id=7315)

> Comss.one DNS также предоставляет доступ к популярным сайтам и сервисам. В частности, вы можете пользоваться ИИ-сервисами (ChatGPT и Sora, Microsoft Copilot, GitHub Copilot, xAI Grok, Google Gemini и Claude AI), или устанавливать обновления антивирусов, инсайдерские сборки и обновления Windows, а также играть в Brawl Stars и сетевые режимы Doom Eternal в России.

Если по каким-либо причинам DNS от `Comss` не работает, то можно использовать альтернативное решение от [XBox DNS](https://xbox-dns.ru/) (не является аффилированным продуктом Microsoft). Процедура настройки не отличается от `Comss DNS`, просто следуйте шагам из инструкции выше, но используйте следующие DNS сервера:
- Основной сервер: `176.99.11.77`
- Дополнительный сервер: `80.78.247.254`
- DNS-Over-HTTPS: `https://xbox-dns.ru/dns-query`
- DNS-Over-TLS/DNS-Over-QUIC: `xbox-dns.ru`

Полный список разблокируемых доменов/сервисов/игр можно найти в их [телеграм-канале](https://t.me/+1mWxunhofUM4M2My)

## 👾 Источники
- [zapret](https://github.com/bol-van/zapret)
- [zapret-win-bundle](https://github.com/bol-van/zapret-win-bundle)
- [nssm](https://github.com/kirillkovalenko/nssm)
- [antifilter.download](https://antifilter.download)
- [community.antifilter.download](https://community.antifilter.download)
- [re:filter](https://github.com/1andrevich/Re-filter-lists)
- [comss.one dns](https://www.comss.ru/page.php?id=7315)
- [xbox-dns.ru](https://xbox-dns.ru)
