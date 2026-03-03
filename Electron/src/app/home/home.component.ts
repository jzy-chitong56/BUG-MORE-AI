import { Component, OnInit, OnDestroy , ViewChild, ElementRef, HostListener, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { ElectronService } from '../core/services/electron/electron.service';

@Injectable({
  providedIn: 'root'
})

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {
  private pathUpdateListener: any;
  Images_ROC_Shown: boolean = false;
  Images_TFT_Shown: boolean = false;
  Images_REF_Shown: boolean = false;
  ROCInstall: boolean = false;
  TFTInstall: boolean = false;
  REFInstall: boolean = false;
  Mode_State: boolean = true;
  BJ_State: number = 1;
  isInteractive: boolean = true;
  modeState: string = '-folder';
  bjState: string = '';
  message: string = '';
  optimize: boolean = true;
  forcelang: boolean = false;
  installEvent: string = 'install'
  gamePaths = {
    TFT: { 
      PATH: null as string | null,
      displayText: '--',
    },
    REFORGED: { 
      PATH: null as string | null,
      displayText: '--',
    },
    ROC: { 
      PATH: null as string | null,
      displayText: '--',
    }
  };

  constructor(
    private electronService: ElectronService, 
  ) {}

  ngOnInit(): void {
    console.log('HomeComponent INIT');
    void this.loadDefaultPath();
    this.UpdateDefaultPath();
  }

  ngOnDestroy(): void {
    if (this.pathUpdateListener) {
      this.electronService.ipcRenderer.removeListener('path-updated', this.pathUpdateListener);
    }
  }

  private UpdateDefaultPath(): void {
    this.pathUpdateListener = (event: any, { pathver, path = '' }) => {
      console.log(`Path updated for ${pathver} : `, path);
      if (pathver in this.gamePaths) {
        this.gamePaths[pathver].PATH = path || null;
        this.gamePaths[pathver].displayText = this.formatPath(path);
        console.log('updated ver Path to : ', this.gamePaths[pathver].PATH, 'Display:', this.gamePaths[pathver].displayText);
      }
    };
    this.electronService.ipcRenderer.on('path-updated', this.pathUpdateListener);
  }

  private async loadDefaultPath(): Promise<void> {
    const settings = await this.electronService.ipcRenderer.invoke('load-path');
    if (settings) {
      console.log('Loaded paths settings:', settings);
      this.gamePaths.TFT.PATH = settings.TFT_PATH;
      this.gamePaths.REFORGED.PATH = settings.REFORGED_PATH;
      this.gamePaths.ROC.PATH = settings.ROC_PATH;
      this.gamePaths.TFT.displayText = this.gamePaths.TFT.PATH ? this.formatPath(this.gamePaths.TFT.PATH) : '--';
      this.gamePaths.REFORGED.displayText = this.gamePaths.REFORGED.PATH ? this.formatPath(this.gamePaths.REFORGED.PATH) : '--';
      this.gamePaths.ROC.displayText = this.gamePaths.ROC.PATH ? this.formatPath(this.gamePaths.ROC.PATH) : '--';
      console.log('REFORGED Path:', this.gamePaths.REFORGED.PATH, 'Display:', this.gamePaths.REFORGED.displayText);
      console.log('TFT Path:', this.gamePaths.TFT.PATH, 'Display:', this.gamePaths.TFT.displayText);
      console.log('ROC Path:', this.gamePaths.ROC.PATH, 'Display:', this.gamePaths.ROC.displayText);
    } else {
      console.error('Error loading paths:', settings);
    }
  }

  private formatPath(path: string, maxLength = 20): string {
    if (!path) return '--';
    if (path.length <= maxLength) return path;
    const parts = path.split(/[\\/]/);
    if (parts.length <= 2) return path;
    const firstPart = parts[0];
    const lastPart = parts[parts.length - 1];
    const middleLength = maxLength - (firstPart.length + lastPart.length + 5);
    if (middleLength > 0) {
      return `${firstPart}/.../${lastPart}`;
    }
    return `${firstPart}/...${lastPart}`;
  }

  async selectPathAndInstall(pathver: 'REFORGED' | 'TFT' | 'ROC') {
    if (this.isInteractive) {
      console.log(`Selecting path and install for ${pathver}`);
      this.electronService.ipcRenderer.send('set-path-and-install', this.Mode_State, this.BJ_State, this.optimize, this.forcelang, pathver);
    }
  }

  @HostListener('mouseenter', ['$event', '$event.target.dataset.action'])
  onMouseEnter(event: MouseEvent, action: string) {
    if (this.isInteractive) {
      switch (action) {
        case 'Roc':
          if (!this.ROCInstall) {
            this.Images_ROC_Shown = true;
          }
          break;
        case 'Tft':
          if (!this.TFTInstall) {
            this.Images_TFT_Shown = true;
          }
          break;
        case 'Ref':
          if (!this.REFInstall) {
            this.Images_REF_Shown = true;
          }
          break;
      }
    };
  }

  @HostListener('mouseout', ['$event', '$event.target.dataset.action'])
  onMouseLeave(event: MouseEvent, action: string) {
    if (this.isInteractive) { 
      switch (action) {
        case 'Roc':
          if (!this.ROCInstall) {
            this.Images_ROC_Shown = false;
          }
          break;
        case 'Tft':
          if (!this.TFTInstall) {
            this.Images_TFT_Shown = false;
          }
          break;
        case 'Ref':
          if (!this.REFInstall) {
            this.Images_REF_Shown = false;
          }
          break;
      }
    };
  }

  @HostListener('click', ['$event', '$event.target.dataset.action'])
  onClick(event: MouseEvent, action: string) {
    if (this.isInteractive) {
      switch (action) {
        case 'Roc':
          if (!this.ROCInstall) {
            this.message = `install${this.modeState}${this.bjState}-ROC`;
            this.Images_ROC_Shown = true;
            this.Images_TFT_Shown = false;
            this.Images_REF_Shown = false;
            this.TFTInstall = false;
            this.REFInstall = false;
            this.ROCInstall = !this.ROCInstall;
            this.electronService.ipcRenderer.send(this.installEvent, 'ROC', this.Mode_State, this.BJ_State, this.optimize, this.forcelang);
            console.log('message', this.message);
          }
          break;
        case 'Tft':
          if (!this.TFTInstall) {
            this.message = `install${this.modeState}${this.bjState}-TFT`;
            this.Images_ROC_Shown = false;
            this.Images_TFT_Shown = true;
            this.Images_REF_Shown = false;
            this.ROCInstall = false;
            this.REFInstall = false;
            this.TFTInstall = !this.TFTInstall;
            this.electronService.ipcRenderer.send(this.installEvent, 'TFT', this.Mode_State, this.BJ_State, this.optimize, this.forcelang);
            console.log('message', this.message);
          }
          break;
        case 'Ref':
          if (!this.REFInstall) {
            this.message = `install${this.modeState}${this.bjState}`;
            this.Images_ROC_Shown = false;
            this.Images_TFT_Shown = false;
            this.Images_REF_Shown = true;
            this.ROCInstall = false;
            this.TFTInstall = false;
            this.REFInstall = !this.REFInstall;
            this.electronService.ipcRenderer.send(this.installEvent, 'REFORGED', this.Mode_State, this.BJ_State, this.optimize, this.forcelang);
            console.log('message', this.message);
          }
          break;
      }
    };
    this.Images_ROC_Shown = false;
    this.Images_TFT_Shown = false;
    this.Images_REF_Shown = false;
    this.ROCInstall = false;
    this.TFTInstall = false;
    this.REFInstall = false;
  }

  onInputChange(inputId: string) {
    if (this.isInteractive) { 
      switch (inputId) {
        case 'ModeSwitch':
          this.Mode_State = !this.Mode_State;
          this.modeState = this.Mode_State ? '-folder' : '-map';
          console.log('mode', this.modeState, this.Mode_State);
          break;
        case 'BJoptionOn':
          this.bjState = '';
          this.BJ_State = 1;
          console.log('BJ', this.bjState);
          break;
        case 'BJoptionVsAI':
          this.bjState = '-vai';
          this.BJ_State = 2;
          console.log('BJ', this.bjState);
          break;
        case 'BJoptionOff':
          this.bjState = '-noc';
          this.BJ_State = 0;
          console.log('BJ', this.bjState);
          break;
        case 'Optimise':
          this.optimize = !this.optimize;
          if (this.optimize) {
            this.forcelang = false;
          }
          break;
        case 'ForceLang':
          this.forcelang = !this.forcelang;
          if (this.forcelang) {
            this.optimize = false;
          }
          break;
      }
    };
  }
}