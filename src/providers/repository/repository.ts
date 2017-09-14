import { Injectable } from '@angular/core';
import { Storage } from '@ionic/storage';
import 'rxjs/add/operator/map';

@Injectable()
export class RepositoryProvider {

  constructor(public storage: Storage) {
  }
  
  getNotes() {
    return this.storage.get('notes');
  }
  
  saveNotes(notes) {
    this.storage.set('notes', JSON.stringify(notes));
  }

}
