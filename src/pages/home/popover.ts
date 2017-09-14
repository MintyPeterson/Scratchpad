import { Component } from '@angular/core';
import { ViewController } from 'ionic-angular';
import { NavParams } from 'ionic-angular';
import { ToastController } from 'ionic-angular';
import { Clipboard } from '@ionic-native/clipboard';

@Component({
  templateUrl: 'popover.html'
})
export class HomePopoverPage {

  constructor(public viewCtrl: ViewController, public navParams: NavParams, public toastCtrl: ToastController, public clipboard: Clipboard) {
  }
  
  public onPasteButtonClick = () => {
    
    this.clipboard.paste().then((resolve: string) => {
      
      let notes = this.navParams.get('notes');
      
      if (notes) {
        this.navParams.data.notes = notes + resolve;
      } else {
        this.navParams.data.notes = resolve;
      }
    });
    
    this.viewCtrl.dismiss(this.navParams);
  }
  
  public onCopyButtonClick = () => {
    
    this.clipboard.copy(this.navParams.data.notes);
    
    let toast = this.toastCtrl.create({
      message: 'Notes copied to clipboard.',
      duration: 2000,
      position: 'bottom'
    });

    toast.present(toast);
    
    this.viewCtrl.dismiss();
  }
  
  public onRemoveEmptyLinesButtonClick = () => {
    
    let notes = this.navParams.get('notes');
    
    if (notes) {
      this.navParams.data.notes = notes.replace(/(^[ \t]*\n)/gm, '');
    }
    
    this.viewCtrl.dismiss(this.navParams);
  }
  
  public onTrimWhitespaceButtonClick = () => {
    
    let notes = this.navParams.get('notes');
    
    if (notes) {
      notes = notes.replace(/^ +| +$/gm, '');
      notes = notes.replace(/ +/gm, ' ');
    
      this.navParams.data.notes = notes;
    }
    
    this.viewCtrl.dismiss(this.navParams);
  }
}