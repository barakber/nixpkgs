{ pkgs }:
{
  enable = true;
  enableContribAndExtras = true;
  config = pkgs.writeText "xmonad.hs" ''
import Data.List (isInfixOf, map)
import Data.Char (toLower)
import qualified Data.Map as Map
import System.IO
import System.Exit
import Control.Concurrent
import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog, doFullFloat, doCenterFloat)
import XMonad.Layout.Grid
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run      (spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Actions.CycleWS
import XMonad.Actions.Submap
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import Data.Function (fix)

--
myTerminal = "urxvtc -tr -sh 20"

myLauncher = "$(yeganesh -x -- -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -nb '#000000' -nf '#FFFFFF' -sb '#7C7C7C' -sf '#CEFFAC')"

myWorkspaces = [ "1:term"
               , "2:edit"
               , "3:temp"
               , "4:web"
               , "5"
               , "6:vm"
               , "7:gimp"
               , "8"
               , "9:tmp"
               ]

--
myManageHook = composeAll
    [ className =? "Chromium-browser"  --> doShift "4:web"
    , className =? "Firefox"           --> doShift "4:web"
    , className =? "Google-chrome"     --> doShift "4:web"
    , className =? "Gimp"              --> doShift "7:gimp"
    , className =? "VirtualBox"        --> doShift "6:vm"
    , className =? "Atom"              --> doShift "2:edit"
    ]

--
myLayout = avoidStruts
    ( Grid
  ||| ThreeColMid 1 (3/100) (1/2)
  ||| Tall 1 (3/100) (1/2)
  ||| Mirror (Tall 1 (3/100) (1/2))
  ||| tabbed shrinkText tabConfig
  ||| Full
  ||| spiral (6/7)
  ||| noBorders (fullscreenFull Full)
    )

--
myNormalBorderColor  = "blue" -- #7c7c7c"
myFocusedBorderColor = "green" -- "#ffb6b0"
myBorderWidth = 1

xmobarTitleColor = "#FFB6B0"
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme
    { activeBorderColor = "#7C7C7C"
    , activeTextColor = "#CEFFAC"
    , activeColor = "#000000"
    , inactiveBorderColor = "#7C7C7C"
    , inactiveTextColor = "#EEEEEE"
    , inactiveColor = "#000000"
    }


--
myModMask = mod1Mask
altMask = mod1Mask

(?) :: Bool -> a -> a -> a
True ? a = const a
False ? a = id

myKeys conf@(XConfig {XMonad.modMask = myModMask}) = Map.fromList $
    [ -- start terminal
      ( (myModMask, xK_Return)
      , spawn $ XMonad.terminal conf
      )

      -- mouse submap
     , ((myModMask, xK_m),
         fix (\cmd ->
           submap . Map.fromList $
             map (\(a,b,c) -> (a, b >> (c ? cmd $ return ())))
             [ ((0, xK_Escape),                return (),                                                         False)
             , ((0, xK_h),                     spawn "xdotool mousemove_relative -- -20 0",                       True)
             , ((0, xK_j),                     spawn "xdotool mousemove_relative --  0  20",                      True)
             , ((0, xK_k),                     spawn "xdotool mousemove_relative --  0 -20",                      True)
             , ((0, xK_l),                     spawn "xdotool mousemove_relative --  20 0",                       True)
             , ((shiftMask, xK_h),             spawn "xdotool mousemove_relative -- -120 0",                       True)
             , ((shiftMask, xK_j),             spawn "xdotool mousemove_relative --  0  120",                      True)
             , ((shiftMask, xK_k),             spawn "xdotool mousemove_relative --  0 -120",                      True)
             , ((shiftMask, xK_l),             spawn "xdotool mousemove_relative --  120 0",                       True)
             , ((altMask, xK_h),               spawn "xdotool mousemove_relative -- -5  0",                       True)
             , ((altMask, xK_j),               spawn "xdotool mousemove_relative --  0  5",                       True)
             , ((altMask, xK_k),               spawn "xdotool mousemove_relative --  0 -5",                       True)
             , ((altMask, xK_l),               spawn "xdotool mousemove_relative --  5  0",                       True)
             , ((0, xK_m),                     spawn "xdotool mousemove --polar  0 0",                            True)
             , ((shiftMask, xK_m),             spawn "xdotool getwindowfocus mousemove --window %1 --polar  0 0", True)
             , ((0, xK_f),                     spawn "xdotool click --clearmodifiers 1 && xdotool click 1",       True)
             , ((0, xK_g),                     spawn "xdotool click --clearmodifiers 3 && xdotool click 3",       True)
             , ((0, xK_v),                     spawn "xdotool key shift+Insert",       True)
             , ((altMask .|. shiftMask, xK_j), spawn "sleep 0.2 && xdotool click --clearmodifiers 4",             True)
             , ((altMask .|. shiftMask, xK_k), spawn "sleep 0.2 && xdotool click --clearmodifiers 5",             True)
             ]))

      -- lock screen
    , ( (myModMask .|. controlMask, xK_l)
      , spawn "/usr/bin/gnome-screensaver-command --lock"
      )

    , ( (myModMask, xK_Escape)
      , toggleWS
      )

--    , ( (myModMask, xK_r)
--      , spawn myLauncher
--      )

      -- randomize background
    , ( (myModMask, xK_p)
      , spawn "feh --bg-fill ~/Pictures/Wallpapers/$(ls ~/Pictures/Wallpapers | shuf -n 1)"
     )

      -- Mute volume.
    , ( (0, xF86XK_AudioMute)
      , spawn "amixer -q set Master toggle"
      )

      -- Decrease volume.
    , ( (0, xF86XK_AudioLowerVolume)
      , spawn "amixer -q set Master 5%-"
      )

      -- Increase volume.
    , ( (0, xF86XK_AudioRaiseVolume)
      , spawn "amixer -q set Master 5%+"
      )

       -- next workspace
     , ( (myModMask, xK_Down)
       ,  nextWS
       )

     , ( (myModMask,xK_Up)
       , prevWS
       )

     , ( (myModMask .|. shiftMask, xK_Down)
       , shiftToNext
       )

     , ( (myModMask .|. shiftMask, xK_Up)
       , shiftToPrev
       )

     , ( (myModMask, xK_Right)
       , nextScreen
       )

     , ( (myModMask, xK_Left)
       , prevScreen
       )

     , ( (myModMask .|. shiftMask, xK_Right)
       , shiftNextScreen
       )

     , ( (myModMask .|. controlMask, xK_j)
       , prevScreen
       )

     , ( (myModMask .|. controlMask, xK_k)
       , nextScreen
       )

     , ( (myModMask .|. shiftMask, xK_Left)
       , shiftPrevScreen
       )

     , ( (myModMask, xK_z)
       , toggleWS
       )

      -- close focused window
    , ( (myModMask .|. shiftMask, xK_c)
      , kill
      )

      -- Cycle through the available layout algorithms.
    , ( (myModMask, xK_space)
      , sendMessage NextLayout
      )

      --  Reset the layouts on the current workspace to default.
    , ( (myModMask .|. shiftMask, xK_space)
      , setLayout $ XMonad.layoutHook conf
      )

      -- Resize viewed windows to the correct size.
    , ( (myModMask, xK_n)
      , refresh
      )

      -- Move focus to the next window.
    , ( (myModMask, xK_Tab)
      , windows W.focusDown
      )

      -- Move focus to the next window.
    , ( (myModMask, xK_j)
      , windows W.focusDown
      )

      -- Move focus to the previous window.
    , ( (myModMask, xK_k)
      , windows W.focusUp
      )

      -- Move focus to the master window.
    -- , ( (myModMask, xK_m)
    --   , windows W.focusMaster
    --   )

      -- Swap the focused window and the master window.
    -- , ( (myModMask, xK_Return)
    --  , windows W.swapMaster
    --  )

      -- Swap the focused window with the next window.
    , ( (myModMask .|. shiftMask, xK_j)
      , windows W.swapDown
      )

      -- Swap the focused window with the previous window.
    , ( (myModMask .|. shiftMask, xK_k)
      , windows W.swapUp
      )

      -- Shrink the master area.
    , ( (myModMask, xK_h)
      , sendMessage Shrink
      )

      -- Expand the master area.
    , ( (myModMask, xK_l)
      , sendMessage Expand
      )

      -- Push window back into tiling.
    , ( (myModMask, xK_t)
      , withFocused $ windows . W.sink
      )

      -- Increment the number of windows in the master area.
    , ( (myModMask, xK_comma)
      , sendMessage (IncMasterN 1)
      )


      -- Decrement the number of windows in the master area.
    , ( (myModMask, xK_period)
      , sendMessage (IncMasterN (-1))
      )

      -- Quit xmonad.
    , ( (myModMask .|. shiftMask, xK_q)
      , io (exitWith ExitSuccess)
      )

      -- Setup second screen
    , ( (myModMask, xK_s)
      , spawn "xrandr --output HDMI-1  --mode 1920x1080 --scale 1x1 --panning 1920x1080+3200+0"
      )

      -- Restart xmonad.
    , ( (myModMask, xK_q)
      , restart "xmonad" True
      )

    , ( (0, xF86XK_MonBrightnessUp)
      , spawn "brightnessctl s 5%+"
      )

    , ( (0, xF86XK_MonBrightnessDown)
      , spawn "brightnessctl s 5%-"
      )

    ] ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [ ((m .|. myModMask, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ] ++

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [ ((m .|. myModMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, m)    <- [(W.view, 0), (W.shift, shiftMask)]
    ]



--
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig {XMonad.modMask = myModMask}) = Map.fromList $
    [ -- mod-button1, Set the window to floating mode and move by dragging
      ( (myModMask, button1)
      , (\w -> focus w >> mouseMoveWindow w)
      )

      -- mod-button2, Raise the window to the top of the stack
    , ( (myModMask, button2)
      , (\w -> focus w >> windows W.swapMaster)
      )

      -- mod-button3, Set the window to floating mode and resize by dragging
    ,   ( (myModMask, button3)
      , (\w -> focus w >> mouseResizeWindow w)
      )

      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

--
myStartupHook = return ()

myLaptopResolution     = "xrandr --output eDP-1   --mode 3200x1800"
myHomeScreenResolution = "xrandr --output DP-1    --mode 1920x1080 --scale 2x2 --panning 3840x2160+3200+0"
myWorkScreenResolution = "xrandr --output HDMI-1  --mode 1920x1080 --scale 1x1 --panning 1920x1080+3200+0"

--
main = do
    spawn "urxvtd"
    -- spawn "setxkbmap -option caps:swapescape"
    -- spawn "setxkbmap -option grp:alt_shift_toggle us,il"
    spawn "sleep 2"
    -- spawn myLaptopResolution
    -- spawn myHomeScreenResolution
    -- spawn myWorkScreenResolution
    -- spawn "xrandr --output DP1  --scale 1.5x1.5"
    -- spawn "xcompmgr -c -f"
    spawn "keynav"
    -- xmproc <- spawnPipe "xmobar /home/barak/.xmonad/xmobar.hs"
    xmonad $ defaults
           { -- logHook = dynamicLogWithPP $ xmobarPP
             --                            { ppOutput = hPutStrLn xmproc
             --                            , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
             --                            , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
             --                            , ppSep = "   "
             --                            }
             manageHook = (isFullscreen --> doFullFloat) <+> manageDocks <+> myManageHook
           , startupHook = setWMName "LG3D"
           , handleEventHook = mconcat
                             [ docksEventHook
                             , handleEventHook defaultConfig
                             ]
           }

--
defaults = gnomeConfig
         { terminal           = myTerminal
         , focusFollowsMouse  = myFocusFollowsMouse
         , borderWidth        = myBorderWidth
         , modMask            = myModMask
         , workspaces         = myWorkspaces
         , normalBorderColor  = myNormalBorderColor
         , focusedBorderColor = myFocusedBorderColor

           -- key bindings
         , keys               = myKeys
         , mouseBindings      = myMouseBindings

           -- hooks, layouts
         , layoutHook         = smartBorders $ myLayout
         , manageHook         = myManageHook
         , startupHook        = myStartupHook
         }
  '';
}
