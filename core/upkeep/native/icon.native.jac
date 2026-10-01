import from "lucide-react-native" {
    Briefcase,
    Check,
    ChevronLeft,
    ChevronRight,
    Dumbbell,
    Flame,
    House,
    Inbox,
    LogOut,
    Moon,
    RefreshCw,
    Sun,
    Trash2,
    TrendingUp,
    WifiOff,
    X
}

glob LUCIDE: dict[str, any] = {
         "today": House,
         "jobs": Briefcase,
         "progress": TrendingUp,
         "check": Check,
         "trash": Trash2,
         "close": X,
         "offline": WifiOff,
         "refresh": RefreshCw,
         "logout": LogOut,
         "sun": Sun,
         "moon": Moon,
         "flame": Flame,
         "workout": Dumbbell,
         "left": ChevronLeft,
         "right": ChevronRight,
         "inbox": Inbox
     };

def:pub Icon(name: str, size: int, color: str, fill: bool = False) -> JsxElement {
    Glyph = LUCIDE[name];
    <Glyph size={size} color={color} fill={color if fill else "none"} strokeWidth={2}/>
}
