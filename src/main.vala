/*
 * main.vala
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
    class App {
        public bool launched_by_ibus;
        public bool verbose;

        public App() {
            // A property declaration ( public bool verbose {get; set; default = false;} )
            // should be much better but Vala prevents getting address of (& operation)
            // properties so a normal member attribute will do.
            this.launched_by_ibus = false;
            this.verbose = false;
        
            // Create an Ibus bus
            var bus = new IBus.Bus();
            bus.disconnected.connect(() => { // Vala's lambda function syntax
                IBus.quit();
            });
            
            // There are 2 ways to launch this binary: automatically when Ibus starts
            // and manually (for testing purpose).
            if (launched_by_ibus)
            {
                bus.request_name("org.freedesktop.IBus.BoGo", 0);
            } else {
                // Create and register a component (only used if this binary is executed manually)
                var component = new IBus.Component("org.freedesktop.IBus.BoGo",          // Name
                                                    "BoGo Component",                    // Description
                                                    "0.1.0",                             // Version
                                                    "GPL",                               // License
                                                    "Trung Ngo <ndtrung4419@gmail.com>", // Author
                                                    "",                                  // Homepage
                                                    "",                                  // Executable path
                                                    "");                                 // Textdomain (for translations)
                                                    
                var engine_desc = new IBus.EngineDesc("bogo",                            // Name
                                                      "Bogo",                            // Long name
                                                      "Bogo",                            // Description
                                                      "vi",                              // Language
                                                      "GPLv3",                           // License
                                                      "Trung Ngo <ndtrung4419@gmail.com>", // Author
                                                      "",                                // Icon 
                                                      "en");                             // Layout
                component.add_engine(engine_desc);
                bus.register_component(component);
            }
            
            // Either way, now that we have the bus up and running, we create
            // and register the factory object (which creates engine instances
            // whenever ibus-bogo is enabled) to it.
            var factory = new IBus.Factory(bus.get_connection());
            factory.add_engine("bogo", typeof(BoGo.Engine));
        }

        public void run() {
            print("%s %s", launched_by_ibus.to_string(), verbose.to_string());
            IBus.main();
        }
        
        public static int main(string[] args) {
            IBus.init();
            var app = new App();
            
            // Vala's syntax is pretty verbose here
            GLib.OptionEntry[] entries = { 
                OptionEntry() {
                    long_name = "ibus",
                    short_name = 'i',
                    flags = 0,
                    arg = OptionArg.NONE,
                    arg_data = &app.launched_by_ibus,
                    description = "Tell the program that it was launched by Ibus"
                    // The <exec> line in bogo.xml tells ibus always to call this with --ibus
                },
                OptionEntry() {
                    long_name = "verbose",
                    short_name = 'v',
                    flags = 0,
                    arg = OptionArg.NONE,
                    arg_data = &app.verbose,
                    description = "Be verbose"
                }
            };
            
            var context = new OptionContext("- Ibus BoGo engine");
            context.add_main_entries(entries, null);
            try {
                context.parse(ref args);
            } catch (OptionError err) {
                print("Cannot parse arguments: %s\n", err.message);
            }
            
            app.run();
            return 0;
        }
    }
}
