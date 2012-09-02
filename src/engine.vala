/*
 * engine.vala
 * 
 * Copyright 2012 Ngô Trung <ndtrung4419@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
 
using IBus;

namespace BoGo {
    class Engine : IBus.Engine {
        private StringBuilder preedit_text;
    
        public Engine(string name, string path, GLib.DBusConnection bus) {
            // C-code legacy. We cannot do a base(name, path, bus) here because
            // Ibus wasn't written in Vala. 
            // See here: https://mail.gnome.org/archives/vala-list/2010-January/msg00006.html
            
            // GObject-like construction style: the Engine() function
            // only creates the object and fills its construct properties
            // while real code gets done in the construct {} block.
            GLib.Object(engine_name:name, object_path:path, connection:bus);
        }
        
        construct {
            preedit_text = new StringBuilder();
        }
        
        // THE trump card, get called whenever a key is pressed and the engine is enabled
        // Pretty limited for now, just implements basic preediting functionalities.
        // Some code is adapted from Long T. Dam <longdt90@gmail.com>'s project.
        public override bool process_key_event(uint keyval, uint keycode, uint modifiers) {
        
            // A key is released - not really important
            if ((modifiers & IBus.ModifierType.RELEASE_MASK) != 0)
            return false;
            
            // We only care about Control and Modifier 1 (Usually Alt_L (0x40), Alt_R (0x6c), Meta_L (0xcd))
            modifiers &= (IBus.ModifierType.CONTROL_MASK | IBus.ModifierType.MOD1_MASK);

            // Control-S (save) ?
            if (modifiers == IBus.ModifierType.CONTROL_MASK && keyval == IBus.s) {
                // Trung: Why true?
                return true;
            }

            // Something else?
            // Trung: this thing is pretty obscure.
            if (modifiers != 0) {
                if (preedit_text.len == 0)
                    return false;
                else
                    return true;
            }
            
            switch (keyval) {
                case IBus.space:
                    commit_string(preedit_text.str);
                    commit_string(" ");
                    reset();
                    return true;
                    break;
                case IBus.Return:
                    commit_string(preedit_text.str);
                    commit_string("\n");
                    reset();
                    return true;
                    break;
                case IBus.BackSpace:
                    preedit_text.erase(preedit_text.len-1,-1); // Remove the last character
                    update_preedit_text(to_text(preedit_text.str), preedit_text.str.length, true);
                    return true;
                    break;
                default:
                    if (is_character(keyval)) {
                        preedit_text.append_unichar(keyval);
                        update_preedit_text(to_text(preedit_text.str), preedit_text.str.length, true);
                        return true;
                    }
                    break;
            } 
            // Trung: not sure what happens if we return false
            // docs says "TRUE for successfully process the key; FALSE otherwise"
            return false;
        }
        
        public override void enable() {
            print("Enabled\n");
            base.enable();
        }
        
        public override void disable() {
            print("Disabled\n");
            reset();
            base.disable();
        }
        
        public override void reset() {
            print("Reseted\n");
            preedit_text.assign("");
            hide_preedit_text();
            base.reset();
        }
        
        /*-- Helpers --*/
        
        private void commit_string(string str) {
            commit_text(to_text(str));
        }
        
        private IBus.Text to_text(string str) {
            var text = new IBus.Text.from_string(str);
            text.append_attribute(IBus.AttrType.UNDERLINE, IBus.AttrUnderline.SINGLE, 0, -1);    
            return text;
        }
        
        private bool is_character (uint keyval) {
            // Using ascii code
            if ((keyval > 32) && (keyval <127))
                return true;
            else
                return false;
        }
    }
}
