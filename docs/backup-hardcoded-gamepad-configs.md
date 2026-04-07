# Backup — Configs manettes hardcodées (état fonctionnel 2026-04-07)

## retroarch.cfg (complet)
```ini
cache_directory = "/tmp/retroarch"
system_directory = "/home/pi/RetroPie/BIOS"
config_save_on_exit = "false"
video_aspect_ratio_auto = "true"
video_threaded = "true"
video_font_size = "24"
core_options_path = "/opt/retropie/configs/all/retroarch-core-options.cfg"
global_core_options = "true"
input_exit_emulator = "escape"
rewind_enable = "false"
rewind_buffer_size = "10"
rewind_granularity = "2"
input_rewind = "r"
video_gpu_screenshot = "true"
input_shader_next = "m"
input_shader_prev = "n"
input_player1_a = "x"
input_player1_b = "z"
input_player1_y = "a"
input_player1_x = "s"
input_player1_start = "enter"
input_player1_select = "rshift"
input_player1_l = "q"
input_player1_r = "w"
input_player1_left = "left"
input_player1_right = "right"
input_player1_up = "up"
input_player1_down = "down"
input_autodetect_enable = "false"
auto_remaps_enable = "true"
input_joypad_driver = "udev"
all_users_control_menu = "true"
remap_save_on_exit = "false"
menu_driver = "rgui"
rgui_aspect_ratio_lock = "2"
rgui_browser_directory = "/home/pi/RetroPie/roms"
rgui_switch_icons = "false"
menu_rgui_shadows = "true"
rgui_menu_color_theme = "29"
menu_show_core_updater = "false"
menu_show_online_updater = "false"
menu_show_restart_retroarch = "false"
menu_disable_search_button = "true"
quick_menu_show_close_content = "false"
quick_menu_show_add_to_favorites = "false"
quick_menu_show_replay = "false"
quick_menu_show_start_recording = "false"
quick_menu_show_start_streaming = "false"
menu_show_overlays = "false"
menu_show_load_content_animation = "false"
core_info_cache_enable = "false"
content_runtime_log = "false"
xmb_show_add = "false"
xmb_show_history = "false"
xmb_show_images = "false"
xmb_show_music = "false"
xmb_shadows_enable = "false"
menu_swap_ok_cancel_buttons = "true"
menu_unified_controls = "true"
quit_press_twice = "false"
video_shader_enable = "true"
quit_on_close_content = "2"
input_enable_hotkey_btn = "8"
input_exit_emulator_btn = "9"
input_menu_toggle_btn = "2"
input_player1_joypad_index = "0"
input_player1_analog_dpad_mode = "1"
input_player1_up_axis = "-1"
input_player1_down_axis = "+1"
input_player1_left_axis = "-0"
input_player1_right_axis = "+0"
input_player1_x_btn = "0"
input_player1_b_btn = "2"
input_player1_a_btn = "1"
input_player1_y_btn = "3"
input_player1_l_btn = "4"
input_player1_r_btn = "5"
input_player1_l2_btn = "6"
input_player1_r2_btn = "7"
input_player1_select_btn = "8"
input_player1_start_btn = "9"
input_player2_joypad_index = "1"
input_player2_analog_dpad_mode = "1"
input_player2_up_axis = "-1"
input_player2_down_axis = "+1"
input_player2_left_axis = "-0"
input_player2_right_axis = "+0"
input_player2_x_btn = "0"
input_player2_b_btn = "2"
input_player2_a_btn = "1"
input_player2_y_btn = "3"
input_player2_l_btn = "4"
input_player2_r_btn = "5"
input_player2_l2_btn = "6"
input_player2_r2_btn = "7"
input_player2_select_btn = "8"
input_player2_start_btn = "9"
```

## es_input.cfg — SNES clone (081f:e401) — GUID H3 SmartPi
```xml
<inputConfig type="joystick" deviceName="USB gamepad" deviceGUID="03004d2a1f08000001e4000010010000">
    <input name="a" type="button" id="1" value="1" />
    <input name="b" type="button" id="2" value="1" />
    <input name="down" type="axis" id="1" value="1" />
    <input name="hotkey" type="button" id="8" value="1" />
    <input name="left" type="axis" id="0" value="-1" />
    <input name="pagedown" type="button" id="5" value="1" />
    <input name="pageup" type="button" id="4" value="1" />
    <input name="right" type="axis" id="0" value="1" />
    <input name="select" type="button" id="8" value="1" />
    <input name="start" type="button" id="9" value="1" />
    <input name="up" type="axis" id="1" value="-1" />
    <input name="x" type="button" id="0" value="1" />
    <input name="y" type="button" id="3" value="1" />
</inputConfig>
```

## es_input.cfg — Twin USB Gamepad (0810:0001) — GUID H3 SmartPi
```xml
<inputConfig type="joystick" deviceName="Twin USB Gamepad" deviceGUID="03001ac9100800000100000010010000">
    <input name="a" type="button" id="2" value="1"/>
    <input name="b" type="button" id="1" value="1"/>
    <input name="select" type="button" id="8" value="1"/>
    <input name="down" type="axis" id="1" value="1"/>
    <input name="left" type="axis" id="0" value="-1"/>
    <input name="right" type="axis" id="0" value="1"/>
    <input name="up" type="axis" id="1" value="-1"/>
    <input name="leftshoulder" type="button" id="4" value="1"/>
    <input name="lefttrigger" type="button" id="6" value="1"/>
    <input name="leftanalogleft" type="axis" id="0" value="-1"/>
    <input name="leftanalogright" type="axis" id="0" value="1"/>
    <input name="leftanalogup" type="axis" id="1" value="-1"/>
    <input name="leftanalogdown" type="axis" id="1" value="1"/>
    <input name="rightshoulder" type="button" id="5" value="1"/>
    <input name="righttrigger" type="button" id="7" value="1"/>
    <input name="start" type="button" id="9" value="1"/>
    <input name="x" type="button" id="0" value="1"/>
    <input name="y" type="button" id="3" value="1"/>
</inputConfig>
```

## es_input.cfg — Twin USB (variante USB Gamepad) — GUID alternatif
```xml
<inputConfig type="joystick" deviceName="USB Gamepad" deviceGUID="03006ce8100800000100000010010000">
    <input name="a" type="button" id="2" value="1"/>
    <input name="b" type="button" id="1" value="1"/>
    <input name="select" type="button" id="8" value="1"/>
    <input name="down" type="axis" id="1" value="1"/>
    <input name="left" type="axis" id="0" value="-1"/>
    <input name="right" type="axis" id="0" value="1"/>
    <input name="up" type="axis" id="1" value="-1"/>
    <input name="leftshoulder" type="button" id="4" value="1"/>
    <input name="lefttrigger" type="button" id="6" value="1"/>
    <input name="leftanalogleft" type="axis" id="0" value="-1"/>
    <input name="leftanalogright" type="axis" id="0" value="1"/>
    <input name="leftanalogup" type="axis" id="1" value="-1"/>
    <input name="leftanalogdown" type="axis" id="1" value="1"/>
    <input name="rightshoulder" type="button" id="5" value="1"/>
    <input name="righttrigger" type="button" id="7" value="1"/>
    <input name="start" type="button" id="9" value="1"/>
    <input name="x" type="button" id="0" value="1"/>
    <input name="y" type="button" id="3" value="1"/>
</inputConfig>
```
