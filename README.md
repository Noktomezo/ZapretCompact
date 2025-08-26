<div align="center">
	<img src="assets/thumbnail.svg" alt="thumbnail"/>
	<p>Компактная версия <a href="https://github.com/bol-van/zapret-win-bundle">zapret-win-bundle</a> от <a href="https://github.com/bol-van">bol-van</a></p>
</div>

## 🔥 Фичи

🍃&nbsp; Оставлены только необходимые бинарники<br> 🧹&nbsp; Автоматическая
остановка службы `WinDivert` при закрытии/остановке программы<br> 💾&nbsp;
Управление службой через [nssm](https://nssm.cc/) для обработки крашей и
распределения ресурсов ЦП<br> ⛑️&nbsp; Работа точечно по заблокированным
ресурсам для предотвращения регресса уже работающих

## 🧩 Установка

1. [Скачать](https://github.com/Noktomezo/ZapretCompact/releases/latest/download/ZapretCompact.zip)
   и распаковать в нужное\* место
2. Запустить `start.cmd`<br> 2.1) Для автоматического запуска при входе в
   систему - запустить `service-install.cmd`<br> 2.2) Для отключения
   автоматического запуска при входе систему - запустить `service-remove.cmd`

> [!WARNING]  
> `*` Не перемещайте/клонируйте в защищенные папки типа `C:\System32` или `C:\Program Files`

## ⚠️ Важно

При использовании программы занимается "слот" VPN, по этому все VPN клиенты
будут работать только в режиме "Прокси" или "Системный прокси". Так же некоторые
античиты могут ругаться на программу из-за компонента `WinDivert` (например
RICOCHET в сериях игр Call Of Duty будет просто закрывать игру без ошибки), так,
что при появлении каких либо "странностей" при использовании системы/запуске игр
первым делом отключайте данную программу.

## 🧐 Дополнительно

В дополнении к обходу DPI можно так же вернуть доступ к некоторым
доменам/ресурсам, которые блокируются "с той стороны" без использования
сторонних приложений и VPN, настроив DNS от:

- [Comss.one DNS](https://www.comss.ru/page.php?id=7315)
- [XBox DNS](https://xbox-dns.ru/) (не является аффилированным продуктом
  Microsoft)
- [dns.malw.link](https://info.dns.malw.link/) ⭐

**Разблокируемые сервисы:**

- ИИ-сервисы (ChatGPT, Sora, Microsoft Copilot, GitHub Copilot, xAI Grok, Google
  Gemini, Claude AI)
- Игры (Brawl Stars, Doom Eternal, Minecraft, Apex Legends, FIFA, Rainbow Six
  Siege)
- Сервисы (Steam, Discord, GitHub)

Полный список разблокируемых ресурсов для каждого DNS сервера ищите на их
официальных сайтах.

## 👾 Источники

- [zapret](https://github.com/bol-van/zapret)
- [zapret-win-bundle](https://github.com/bol-van/zapret-win-bundle)
- [nssm](https://github.com/kirillkovalenko/nssm)
- [antifilter.download](https://antifilter.download)
- [community.antifilter.download](https://community.antifilter.download)
- [re:filter](https://github.com/1andrevich/Re-filter-lists)
- [comss.one dns](https://www.comss.ru/page.php?id=7315)
- [xbox-dns.ru](https://xbox-dns.ru)
- [dns.malw.link](https://info.dns.malw.link/)
