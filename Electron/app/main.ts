import { app, BrowserWindow, dialog, Menu, screen } from 'electron';
import * as path from 'path';
import * as fs from 'fs';
import * as remote from '@electron/remote/main';
import { InstallModel } from '../commons/models';
const ipcMain = require('electron').ipcMain;
const cp = require('child_process');

type Settings = {
  TFT_PATH?: string | null;
  ROC_PATH?: string | null;
  REFORGED_PATH?: string | null;
  [key: string]: any;
};

let win: BrowserWindow = null;
let translations: { [key: string]: string } = {};
let currentLanguage: string = "English";
const documentsPath = app.getPath('documents');
const args = process.argv.slice(1),
  serve = args.some(val => val === '--serve');

// needed to call remote inside app
remote.initialize();

// disable default menu
Menu.setApplicationMenu(null);

const isDev = () => {
  return require.main.filename.indexOf('app.asar') === -1;
}

const createWindow = (): BrowserWindow => {
  const size = screen.getPrimaryDisplay().workAreaSize;
  // Create the browser window.
  win = new BrowserWindow({
    x: 0,
    y: 0,
    width: size.width,
    height: size.height,
    minWidth: 1280,
    minHeight: 940,
    webPreferences: {
      devTools: true,
      nodeIntegration: true,
      allowRunningInsecureContent: (serve),
      contextIsolation: false,  // false if you want to run e2e test with Spectron
    },
  });

  // needed to remote work with electron > 14...
  remote.enable(win.webContents);

  if (serve) {
    const debug = require('electron-debug');
    debug();

    // hot reload frontend
    require('electron-reloader')(module);
    win.loadURL('http://localhost:4200');
  } else {
    // Path when running electron executable
    let pathIndex = './index.html';

    if (fs.existsSync(path.join(__dirname, '../dist/index.html'))) {
       // Path when running electron in local folder
      pathIndex = '../dist/index.html';
    }

    const url = new URL(path.join('file:', __dirname, pathIndex));
    win.loadURL(url.href);
  }

  // Emitted when the window is closed.
  win.on('closed', () => {
    // Dereference the window object, usually you would store window
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    win = null;
  });

  return win;
}

const getversionpath = (pathver: string, settings: Settings): string => {
  win.webContents.send('on-install-console', `get version path : ${JSON.stringify(settings)}, settings path : ${settings[`${pathver}_PATH`]}`);
  if (pathver == "REFORGED") {
    return settings.REFORGED_PATH || '';
  } else if (pathver == "TFT") {
    return settings.TFT_PATH || '';
  } else if (pathver == "ROC") {
    return settings.ROC_PATH || '';
  }
  return '';
}

const execInstall = async (signal, commander: number = 1, isMap: boolean = false, ver: string = "REFORGED", forceLang: boolean, pathver: string = "REFORGED") => {
  const controller = new AbortController();
  let response;
  const settingsPath = path.join(app.getPath('userData'), 'settings.json');
  let settings: Settings = {};
  let usepath = null;
  if (fs.existsSync(settingsPath)) {
    settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
    usepath = getversionpath(pathver, settings);
    win.webContents.send('on-install-console', `${pathver} default path : ${usepath}`);
  }
  if (usepath !== null && usepath !== undefined && usepath !== '') {
    if (isMap) {
      response = dialog.showOpenDialogSync(win, {
        title: translations["PAGES.ELECTRON.OPEN_MAP"] || '',
        properties: ['openFile'] ,
        filters: [
            { name: translations["PAGES.ELECTRON.MAPFILE"] || '', extensions: ['w3x', 'w3m'] },
        ],
        defaultPath: usepath,
      });
      if (response && (response?.length > 0)) {
        usepath = null; // wait updata path , maybe selected other path
      }
    } else {
      response = [usepath];
    }
  } else {
    win.webContents.send('on-install-console', 'Choose path');
    response = dialog.showOpenDialogSync(win, {
      // TODO: add i18n here
      title: isMap ? translations["PAGES.ELECTRON.OPEN_MAP"] || '': translations["PAGES.ELECTRON.OPEN_DIR"] || '',
      // TODO: Change to let multiples selections when is map
      properties: isMap ? ['openFile'] : ['openDirectory'],
      // TODO: add i18n here
      filters: isMap ? [
          { name: translations["PAGES.ELECTRON.MAPFILE"] || '', extensions: ['w3x', 'w3m'] },
      ] : null,
      defaultPath: documentsPath,
    });
  }

  let child;

  // passing reference to external call back
  signal = controller.signal;

  let currentExecDir = `./AMAI-release/`,
    currentScriptDir = './AMAI-release/';

  if (!isDev()) {
    currentExecDir = `./AMAI/`;
    currentScriptDir = path.join(
      __dirname,
      `../${currentExecDir}`
    );
  }

  /** uncomment to debbug */
  // const ls = cp.spawnSync(
  //   `ls`,
  //   [`./resources`,],
  //   { encoding : `utf8` }
  // );
  // // process.send(ls.stdout);
  // win.webContents.send('on-install-message', '__dirname: ' + __dirname);
  // win.webContents.send('on-install-message', 'ls: ' + ls.stdout);
  // win.webContents.send('on-install-message', 'isProd: ' + !isDev());
  // win.webContents.send('on-install-message', 'currentExecDir: ' + currentExecDir);
  // win.webContents.send('on-install-message', `install js path: ../${currentExecDir}install.js`);

  if (!response || (response?.length === 0)) {
    win.webContents.send('on-install-empty');
    return;
  }

  if (usepath === null) {
    if (!isMap) {
      usepath = response[0];
    } else {
      usepath = path.dirname(response[0]);
    }
    const finalPath = usepath ? path.resolve(usepath) : null;
    settings[`${pathver}_PATH`] = finalPath;
    fs.writeFileSync(settingsPath, JSON.stringify(settings));
    win.webContents.send('on-install-console', `Default path updated to: ${finalPath}`);
    win.webContents.send('path-updated', { pathver: pathver, path: finalPath });
  }
  // open modal on front
  win.webContents.send('on-install-init', <InstallModel>{
    response: response[0],
    commander,
    isMap
  });

  // Change the relative path from where the script will be executed
  // MPQEditor and AddToMPQ only work when files and folders are in same directory
  try {
     process.chdir(currentScriptDir);
  } catch (err) {
    console.log('error:', err.message);

    /** uncomment to debbug */
    // win.webContents.send('on-install-message', 'Error: ' + err.message);
  }

  // init install proccess
  try {
    child = cp.fork(
      require.resolve(
        path.join(
          __dirname,
          `../${currentExecDir}install.js`
        )
      ),
      [ response[0], commander, ver, forceLang ? currentLanguage : '-' ],
      { signal },
      (err) => {
        win.webContents.send('on-install-error', err);
      }
    );

    // send messages to modal on front
    child.on('message', (message) => {
      if (typeof message === 'object' && message.type === 'progress') {
        // Send progress updates via dedicated channel
        console.log('progress:', message);
        win.webContents.send('on-install-progress', message);
      } else {
        // Send regular messages via standard channel
        win.webContents.send('on-install-message', message);
      }
    });

    // close modal on process finishes
    child.on('exit', () => {
      win.webContents.send('on-install-exit');
    });
  } catch (err) {
    win.webContents.send('on-install-error', err.message);
  }
}

const GetDefaultPath = () => {
  ipcMain?.handle('load-path', async (_) => {
    const settingsPath = path.join(app.getPath('userData'), 'settings.json');
    let settings: Settings = {};
    if (fs.existsSync(settingsPath)) {
      settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
      win.webContents.send('on-install-console',`Loaded paths : REFORGED : ${settings.REFORGED_PATH} , TFT : ${settings.TFT_PATH} , ROC : ${settings.ROC_PATH}`);
      return { REFORGED_PATH: settings.REFORGED_PATH || null, TFT_PATH: settings.TFT_PATH || null, ROC_PATH: settings.ROC_PATH || null };
    }
    win.webContents.send('on-install-console', `Loading path file failed , using defaults`);
    return { REFORGED_PATH: null, TFT_PATH: null, ROC_PATH: null };
  });
}

const SetDefaultPath = () => {
  ipcMain?.on('set-path-and-install', async (_event, toFolder: boolean, commander: number, optimize: boolean, forceLang: boolean, pathver: string = "REFORGED") => {
    const settingsPath = path.join(app.getPath('userData'), 'settings.json');
    let settings: Settings = {};
    let usepath = documentsPath;
    let result;
    let signal = {};
    win.webContents.send('on-install-console', `Selecting path and install , version : ${pathver}`);
    if (toFolder) {
    if (fs.existsSync(settingsPath)) {
      win.webContents.send('on-install-console', `Get default path`);
      settings = JSON.parse(fs.readFileSync(settingsPath, 'utf8'));
      usepath = getversionpath(pathver, settings);
        if (!usepath || usepath === '' || usepath === null || !fs.existsSync(usepath)) {
        usepath = documentsPath;
      }
    }
      result = dialog.showOpenDialogSync(win, {
      title: translations["PAGES.ELECTRON.OPEN_DIR"] || '',
      properties: ['openDirectory'],
        defaultPath: usepath
    });
    if (result && (result?.length > 0)) {
        usepath = result[0] ? path.resolve(result[0]) : documentsPath;
      settings[`${pathver}_PATH`] = usepath;
      win.webContents.send('on-install-console', `Set path : ${usepath}`);
      try {
        fs.writeFileSync(settingsPath, JSON.stringify(settings));
        win.webContents.send('path-updated', { pathver: pathver, path: usepath });
          execInstall(signal, commander, !toFolder, optimize ? `OPT${pathver}` : pathver, forceLang, pathver);
      } catch (err) {
        win.webContents.send('on-install-console', `Set path failed: ${err.message}`);
      }
    } else {
        win.webContents.send('on-install-console', `Path selection was cancelled`);
      }
    } else {
      execInstall(signal, commander, !toFolder, optimize ? `OPT${pathver}` : pathver, forceLang, pathver);
    }
  });
}

const installProcess = () => {
  let signal = {};

  ipcMain?.on('install', async (_event, ver: string, toFolder: boolean, commander: number, optimize: boolean, forceLang: boolean) => {
    const pathver = ver;
    execInstall(signal, commander, !toFolder, optimize ? `OPT${ver}` : ver, forceLang, pathver);
  });

  // TODO: stop process with signal
  ipcMain?.on('on-stop-process', async () => {
    // stop process here
  });
}

const init = () => {
  try {
    // This method will be called when Electron has finished
    // initialization and is ready to create browser windows.
    // Some APIs can only be used after this event occurs.
    // Added 400 ms to fix the black background issue while using transparent window. More detais at https://github.com/electron/electron/issues/15947
    app.on('ready', () => {
      setTimeout(() => {
        createWindow();
      }, 400)
    });


    // Quit when all windows are closed.
    app.on('window-all-closed', () => {
      // On OS X it is common for applications and their menu bar
      // to stay active until the user quits explicitly with Cmd + Q
      if (process.platform !== 'darwin') {
        app.quit();
      }
    });

    app.on('activate', () => {
      // On OS X it's common to re-create a window in the app when the
      // dock icon is clicked and there are no other windows open.
      if (win === null) {
        createWindow();
      }
    });

  } catch (e) {
    // Catch Error
    // throw e;
  }
}

const installTrans = () => {
  ipcMain?.on('Trans', (_event, currentLang: string, data) => {
    console.log(`Setting language to:${currentLang}`);
    switch (currentLang) {
      case 'en':
        currentLanguage = "English";
        break;
      case 'zh':
        currentLanguage = "Chinese";
        break;
      case 'fr':
        currentLanguage = "French";
        break;
      case 'de':
        currentLanguage = "Deutsch";
        break;
      case 'no':
        currentLanguage = "Norwegian";
        break;
      case 'pt':
        currentLanguage = "Portuguese";
        break;
      case 'ro':
        currentLanguage = "Romanian";
        break;
      case 'ru':
        currentLanguage = "Russian";
        break;
      case 'es':
        currentLanguage = "Spanish";
        break;
      case 'sv':
        currentLanguage = "Swedish";
        break;
      default:
        currentLanguage = "English";
        console.log('Current Language: Unknown so change to English');
    }
    translations = data as { [key: string]: string };
    if (win != null) {
      win.setTitle(translations['PAGES.HOME.TITLE'] || '')
    }
  });
}

init();
installTrans();
installProcess();
GetDefaultPath();
SetDefaultPath();