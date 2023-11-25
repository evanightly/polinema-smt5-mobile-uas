/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./resources/**/*.blade.php",
        "./resources/**/*.js",
        "./resources/**/*.vue",
    ],
    theme: {
        extend: {},
    },
    daisyui: {
        themes: [
            {
                customLightTheme: {
                    ...require("daisyui/src/theming/themes")["light"],
                    "primary": "#2563eb",
                    "secondary": "#7c3aed",
                    "accent": "#f97316",
                    // "neutral": "#ffffff",
                    "info": "#22d3ee",
                    "success": "#22c55e",
                    "warning": "#fbbf24",
                    "error": "#e11d48",

                    "--rounded-box": "1rem", // border radius rounded-box utility class, used in card and other large boxes
                    "--rounded-btn": "0.5rem", // border radius rounded-btn utility class, used in buttons and similar element
                    "--rounded-badge": "1.9rem", // border radius rounded-badge utility class, used in badges and similar
                    "--animation-btn": "0.25s", // duration of animation when you click on button
                    "--animation-input": "0.2s", // duration of animation for inputs like checkbox, toggle, radio, etc
                    "--btn-focus-scale": "0.95", // scale transform of button when you focus on it
                    "--border-btn": "1px", // border width of buttons
                    "--tab-border": "1px", // border width of tabs
                    "--tab-radius": "0.5rem", // border radius of tabs
                },
                customDarkTheme: {
                    ...require("daisyui/src/theming/themes")["dark"],
                    "primary": "#2563eb",
                    "secondary": "#7c3aed",
                    "accent": "#f97316",
                    // "neutral": "#ffffff",
                    "info": "#22d3ee",
                    "success": "#22c55e",
                    "warning": "#fbbf24",
                    "error": "#e11d48",

                    "--rounded-box": "1rem", // border radius rounded-box utility class, used in card and other large boxes
                    "--rounded-btn": "0.5rem", // border radius rounded-btn utility class, used in buttons and similar element
                    "--rounded-badge": "1.9rem", // border radius rounded-badge utility class, used in badges and similar
                    "--animation-btn": "0.25s", // duration of animation when you click on button
                    "--animation-input": "0.2s", // duration of animation for inputs like checkbox, toggle, radio, etc
                    "--btn-focus-scale": "0.95", // scale transform of button when you focus on it
                    "--border-btn": "1px", // border width of buttons
                    "--tab-border": "1px", // border width of tabs
                    "--tab-radius": "0.5rem", // border radius of tabs
                }
            },
        ],
    },
    plugins: [require("daisyui")],
}
