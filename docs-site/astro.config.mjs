// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

export default defineConfig({
	site: 'https://docs.nubosuite.tech',
	integrations: [
		starlight({
			title: 'Nubo OS Docs',
			description: 'Documentation for Nubo OS: the desktop, the server, and everything you need to install, run and update them.',
			logo: { light: './src/assets/nubo-mark-dark.svg', dark: './src/assets/nubo-mark-light.svg', alt: 'Nubo' },
			favicon: '/favicon.svg',
			customCss: ['./src/styles/nubo.css'],
			head: [
				{ tag: 'link', attrs: { rel: 'preconnect', href: 'https://fonts.googleapis.com' } },
				{ tag: 'link', attrs: { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap' } },
			],
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/Chandorkar-Technologies/nubo-os' }],
			editLink: { baseUrl: 'https://github.com/Chandorkar-Technologies/nubo-os/edit/master/docs-site/' },
			lastUpdated: true,
			sidebar: [{ label: 'Welcome', items: [{ slug: 'index' }] }],
		}),
	],
});
