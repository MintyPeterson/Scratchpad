import { Component } from '@angular/core';
import { NavController } from 'ionic-angular';
import { AlertController } from 'ionic-angular';
import { PopoverController} from 'ionic-angular';
import { RepositoryProvider } from '../../providers/repository/repository';
import { HomePopoverPage } from './popover';

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {

  notes: string;

  constructor(public navCtrl: NavController, public alertCtrl: AlertController, public popoverCtrl: PopoverController, public repository: RepositoryProvider) {
    
    this.repository.getNotes().then((notes) => {
      if (notes) {
        this.notes = JSON.parse(notes);
      }
    });
  }
  
  public onNotesChange = () => {
    
    this.repository.saveNotes(this.notes);
  }

  public onPopoverButtonClick = (ev) => {
    
    let popover = this.popoverCtrl.create(HomePopoverPage, {
      notes: this.notes
    });
    
    popover.present({
      ev: ev
    });
    
    popover.onDidDismiss((navParams) => {
      if (navParams) {
        this.notes = navParams.data.notes;
      }
    })
  }

  public onTrashButtonClick = () => {
    
    let confirm = this.alertCtrl.create({
      title: 'Clear scratchpad?',
      message: 'All notes will be deleted.',
      buttons: [
        {
          text: 'Cancel'
        },
        {
          text: 'Clear',
          handler: () => {
            this.notes = null;
          }
        }
      ]
    });
    
    confirm.present();
  }
}
