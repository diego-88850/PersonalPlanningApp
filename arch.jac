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
    utils --> core.site.ui.Navbar { cn }
    utils --> core.site.ui.accordion { cn }
    utils --> core.site.ui.alert_dialog { cn }
    utils --> core.site.ui.avatar { cn }
    utils --> core.site.ui.badge { cn }
    utils --> core.site.ui.button { cn }
    utils --> core.site.ui.card { cn }
    utils --> core.site.ui.carousel { cn }
    utils --> core.site.ui.dialog { cn }
    utils --> core.site.ui.dropdown_menu { cn }
    utils --> core.site.ui.empty { cn }
    utils --> core.site.ui.field { cn }
    utils --> core.site.ui.hover_card { cn }
    utils --> core.site.ui.input { cn }
    utils --> core.site.ui.label { cn }
    utils --> core.site.ui.select { cn }
    utils --> core.site.ui.separator { cn }
    utils --> core.site.ui.skeleton { cn }
    utils --> core.site.ui.tabs { cn }
    utils --> core.site.ui.textarea { cn }
    utils --> core.site.ui.tooltip { cn }
}

impl import core.brand {
    logo --> core.brand.styles { logo_xml }
    theme --> core.upkeep.native.components.BridgeBanner { useTheme }
    theme --> core.upkeep.native.components.StatusView { useTheme }
    theme --> core.upkeep.native.components.TabBar { useTheme }
    theme --> core.site.ui.Navbar { useTheme }
    tokens --> core.brand.styles { Colors, dark_palette, font_family, fonts, light_palette, radii, spacing }
    tokens --> core.brand.theme { Colors, dark_palette, light_palette }
    tokens --> core.upkeep.native.theme { Colors, font_family, fonts, radii, spacing }
}

impl import core.upkeep {
    registration --> core.upkeep.session { register_with_challenge }
}

impl import core.upkeep.native {
    icon --> core.upkeep.native.components.BridgeBanner { Icon }
    icon --> core.upkeep.native.components.StatusView { Icon }
    icon --> core.upkeep.native.components.TabBar { Icon }
    theme --> core.upkeep.native.components.BridgeBanner { makeStyles }
    theme --> core.upkeep.native.components.StatusView { makeStyles }
    theme --> core.upkeep.native.components.TabBar { makeStyles }
}

impl import core.site.ui {
    Navbar --> core.site.ui.SiteShell { Navbar }
    SiteShell --> web.pages.layout { SiteShell }
    button --> core.site.ui.Navbar { buttonVariants }
    button --> core.site.ui.NotFound { buttonVariants }
    button --> core.site.ui.alert_dialog { Button }
    button --> core.site.ui.carousel { Button }
    button --> core.site.ui.dialog { buttonVariants }
    label --> core.site.ui.field { Label }
    separator --> core.site.ui.field { Separator }
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
    rules --> core.server {
        GOAL_KINDS,
        NAME_LIMIT,
        STATUSES,
        completion_pct,
        streaks,
        valid_day,
        valid_name,
        week_so_far
    }
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
}
