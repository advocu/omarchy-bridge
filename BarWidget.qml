// Bridge bar widget: the bridge-table glyph (a table with four seats) in the bar. Click (or `omarchy-shell bridge toggle`) opens the game in its own
// app window; clicking again closes it. All the work is in bin/bridge (opens game/index.html from file:// in a browser app
// window); this file only starts that script. The icon is drawn as a QML Shape,
// bar foreground, accent on hover and while the game is open. Only the icon follows the theme; the game keeps its palette.
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "bridge"

  readonly property string pluginDir: Qt.resolvedUrl(".").toString().replace("file://", "")
  readonly property string launcher: pluginDir + "bin/bridge"
  property bool running: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function run(action) {
    if (actionProc.running) return
    actionProc.command = ["bash", root.launcher, action]
    actionProc.running = true
  }
  function open() { run("open") }
  function close() { run("close") }
  function toggle() { run("toggle") }
  function refresh() { if (!statusProc.running) statusProc.running = true }

  // Quickshell's own IpcHandler (Quickshell.Io): ShellIpc only exists in newer Omarchy shells ("ShellIpc is not a
  // type" on older ones). Same pattern as the Solar Scope plugin. `omarchy-shell bridge toggle` / `qs ipc call bridge toggle`.
  IpcHandler {
    target: "bridge"
    function open(): void { root.open() }
    function close(): void { root.close() }
    function toggle(): void { root.toggle() }
  }

  // Starts or stops the window; the script returns as soon as the window is up (the browser window keeps running
  // in its own session), so this never blocks the shell.
  Process {
    id: actionProc
    onExited: function() { root.refresh() }
  }

  // `bin/bridge status` exits 0 while the table window is open; used only to tint the icon.
  Process {
    id: statusProc
    command: ["bash", root.launcher, "status"]
    onExited: function(exitCode) { root.running = exitCode === 0 }
  }

  // Remove / uninstall: the shell unloads the plugin (destroying this widget) and deletes its folder (or unlinks it, or
  // moves it to a backup). The hook reads bin/bridge into memory at once (the folder may be gone a moment later), then
  // checks every 0.5 s for 30 s whether the plugin is still installed; when it is not, it runs that copy's `close`:
  // the same graceful window close as the bar click (hl.dsp.window.close, so Chrome flushes the autosave), then TERM,
  // then KILL 3 s later. "Installed" = the folder exists and, when the path QML gave us is outside
  // ~/.config/omarchy/plugins but an entry there linked to it at unload (a symlink install resolved to its real
  // path), that entry still resolves to it.
  // A plain shell reload keeps the folder, so the game stays open. If the script could not be read, it falls back to
  // TERM/KILL by profile (pkill -f; the flag is assembled at run time so this hook's own cmdline never matches).
  Component.onDestruction: Quickshell.execDetached(["bash", "-c",
    "s=$(cat \"$1/bin/bridge\" 2>/dev/null); d=${1%/}; p=${XDG_CONFIG_HOME:-$HOME/.config}/omarchy/plugins; " +
    "r=$(realpath -e \"$d\" 2>/dev/null); " +
    "lk() { for e in \"$p\"/*; do [ \"$(realpath -e \"$e\" 2>/dev/null)\" = \"$r\" ] && return 0; done; return 1; }; " +
    "v=0; case \"$d\" in \"$p\"/*) ;; *) lk && v=1 ;; esac; " +
    "on() { [ -d \"$d\" ] || return 1; [ $v = 0 ] || lk; }; " +
    "for i in $(seq 60); do sleep 0.5; on && continue; [ -n \"$s\" ] && exec bash -c \"$s\" bridge close; " +
    "f=--user-data-; f=\"${f}dir=${XDG_CACHE_HOME:-$HOME/.cache}/bridge/browser( |$)\"; " +
    "pkill -TERM -f -- \"$f\" 2>/dev/null; sleep 3; pkill -KILL -f -- \"$f\" 2>/dev/null; exit 0; done; true",
    "bridge-remove", root.pluginDir])

  Timer { interval: 5000; running: true; repeat: true; triggeredOnStart: true; onTriggered: root.refresh() }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    foreground: button.tooltipHovered ? Commons.Color.accent : (root.bar ? root.bar.barForeground : Commons.Color.foreground)
    active: root.running
    activeColor: Commons.Color.accent
    tooltipText: root.running ? "Bridge: close the table" : "Bridge"
    // Bridge-table glyph (viewBox 0 0 12 12, even-odd); BarIconContent scales it to Style.bar.iconSize
    iconComponent: Component {
      Shape {
        width: 12
        height: 12
        layer.enabled: true
        layer.samples: 4
        preferredRendererType: Shape.CurveRenderer
        ShapePath {
          fillRule: ShapePath.OddEvenFill
          strokeWidth: -1
          fillColor: button.active ? button.activeColor : button.foreground
          PathSvg { path: "M3 3H9V9H3ZM4 4H8V8H4ZM5 0H7V2H5ZM10 5H12V7H10ZM5 10H7V12H5ZM0 5H2V7H0Z" }
        }
      }
    }
    onPressed: function(b) { if (b === Qt.LeftButton) root.toggle() }
  }
}
