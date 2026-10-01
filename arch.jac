impl import {
    edge CoreInternal: core.* --> core.*;
    edge AppOverCore: core.* --> web.* | mobile.* | cli.*;
    edge WebInternal: web.* --> web.*;
    edge MobileInternal: mobile.* --> mobile.*;
    edge CliInternal: cli.* --> cli.*;
    edge BridgeFunnel: jaclang.server | jaclang.server.bridge --> cli.main | cli.commands.*;
}

impl import core {
    async_utils --> core.upkeep.registration { sleep }
    utils --> core.site.planner.AuthForm | core.site.planner.GoalsTab | core.site.planner.JobsTab | core.site.planner.Planner | core.site.planner.TodayTab { cn }
    utils --> core.site.ui.Navbar { cn }
    utils --> core.site.ui.badge { cn }
    utils --> core.site.ui.button { cn }
    utils --> core.site.ui.card { cn }
    utils --> core.site.ui.input { cn }
    utils --> core.site.ui.textarea { cn }
}

impl import core.brand {
    logo --> core.brand.styles { logo_xml }
    theme --> core.upkeep.native.UpkeepMobile | core.upkeep.native.components.BridgeBanner | core.upkeep.native.components.StatusView | core.upkeep.native.components.TabBar | core.upkeep.native.screens.AuthScreen | core.upkeep.native.screens.JobsScreen | core.upkeep.native.screens.ProgressScreen | core.upkeep.native.screens.TodayScreen { useTheme }
    theme --> core.site.ui.Navbar { useTheme }
    tokens --> core.brand.styles { Colors, dark_palette, font_family, fonts, light_palette, radii, spacing }
    tokens --> core.brand.theme { Colors, dark_palette, light_palette }
    tokens --> core.upkeep.native.theme { Colors, fonts, radii, spacing }
}

impl import core.upkeep {
    dates --> core.upkeep.state { local_today, shift_day }
    dates --> core.site.planner.GoalsTab { pretty_day }
    dates --> core.upkeep.native.screens.ProgressScreen { pretty_day }
    dates --> core.site.planner.JobsTab | core.upkeep.native.screens.JobsScreen { short_day }
    dates --> core.site.planner.TodayTab | core.upkeep.native.screens.TodayScreen { local_today, pretty_day }
    registration --> core.upkeep.session { register_with_challenge }
    session --> core.site.planner.AuthForm | core.upkeep.native.screens.AuthScreen | core.upkeep.state { Session }
    session --> core.upkeep.state { useSession }
    state --> core.site.planner.GoalsTab | core.site.planner.JobsTab | core.site.planner.TodayTab | core.upkeep.native.screens.JobsScreen | core.upkeep.native.screens.ProgressScreen | core.upkeep.native.screens.TodayScreen { UpkeepState }
    state --> core.site.planner.Planner | core.upkeep.native.UpkeepMobile { useUpkeep }
}

impl import core.upkeep.native {
    UpkeepMobile --> mobile.main { UpkeepMobile }
    icon --> core.upkeep.native.UpkeepMobile | core.upkeep.native.components.BridgeBanner | core.upkeep.native.components.StatusView | core.upkeep.native.components.TabBar | core.upkeep.native.screens.AuthScreen | core.upkeep.native.screens.JobsScreen | core.upkeep.native.screens.ProgressScreen | core.upkeep.native.screens.TodayScreen { Icon }
    theme --> core.upkeep.native.UpkeepMobile | core.upkeep.native.components.BridgeBanner | core.upkeep.native.components.StatusView | core.upkeep.native.components.TabBar | core.upkeep.native.screens.AuthScreen | core.upkeep.native.screens.JobsScreen | core.upkeep.native.screens.ProgressScreen | core.upkeep.native.screens.TodayScreen { makeStyles }
}

impl import core.upkeep.native.components {
    BridgeBanner --> core.upkeep.native.UpkeepMobile { BridgeBanner }
    StatusView --> core.upkeep.native.screens.JobsScreen | core.upkeep.native.screens.ProgressScreen | core.upkeep.native.screens.TodayScreen { EmptyState }
    TabBar --> core.upkeep.native.UpkeepMobile { TabBar }
}

impl import core.upkeep.native.screens {
    AuthScreen --> core.upkeep.native.UpkeepMobile { AuthScreen }
    JobsScreen --> core.upkeep.native.UpkeepMobile { JobsScreen }
    ProgressScreen --> core.upkeep.native.UpkeepMobile { ProgressScreen }
    TodayScreen --> core.upkeep.native.UpkeepMobile { TodayScreen }
}
impl import core.site.ui {
    Navbar --> core.site.ui.SiteShell { Navbar }
    SiteShell --> web.pages.layout { SiteShell }
    button --> core.site.planner.AuthForm | core.site.planner.GoalsTab | core.site.planner.JobsTab | core.site.planner.Planner | core.site.planner.TodayTab { Button }
    button --> core.site.ui.Navbar { buttonVariants }
    button --> core.site.ui.NotFound { buttonVariants }
    card --> core.site.planner.AuthForm | core.site.planner.JobsTab { Card, CardContent }
    card --> core.site.planner.GoalsTab | core.site.planner.TodayTab { Card, CardContent, CardHeader, CardTitle }
    badge --> core.site.planner.GoalsTab { Badge }
    input --> core.site.planner.AuthForm | core.site.planner.GoalsTab | core.site.planner.JobsTab | core.site.planner.TodayTab { Input }
    textarea --> core.site.planner.TodayTab { Textarea }
}

impl import cli.commands {
    auth --> cli.main { apply_auth, run_login, run_logout, run_register }
    common --> cli.commands.auth | cli.commands.plan { EXIT_FAILURE, EXIT_OK, say, warn }
    common --> cli.main { EXIT_OK, EXIT_USAGE, explain_bridge_error, say, warn }
    plan --> cli.main {
        run_add_habit,
        run_add_job,
        run_check,
        run_log_workout,
        run_today,
        today_str
    }
}

impl import core {
    rules --> core.server { completion_pct, streaks, valid_day, week_so_far }
    validation --> core.server | core.upkeep.state { name_limit, valid_name }
    validation --> core.server | core.site.planner.JobsTab | core.upkeep.native.screens.JobsScreen { statuses }
    validation --> core.server { goal_kinds, text_limit, valid_text }
    server --> cli.commands.plan {
        GoalView,
        HabitView,
        Result,
        Today,
        WorkoutView,
        add_application,
        add_habit,
        get_today,
        list_habits,
        log_workout,
        set_check
    }
    server --> cli.main { ping }
    server --> core.site.planner.JobsTab { ApplicationView }
    server --> core.upkeep.state {
        ApplicationView,
        Result,
        Today,
        WorkoutView,
        add_application,
        add_habit,
        archive_habit,
        delete_item,
        get_today,
        list_applications,
        list_workouts,
        log_workout,
        set_check,
        set_goal,
        update_application
    }
}

impl import core.site.planner {
    AuthForm --> core.site.planner.Planner { AuthForm }
    GoalsTab --> core.site.planner.Planner { GoalsTab }
    JobsTab --> core.site.planner.Planner { JobsTab }
    Planner --> web.pages.index { Planner }
    TodayTab --> core.site.planner.Planner { TodayTab }
}
