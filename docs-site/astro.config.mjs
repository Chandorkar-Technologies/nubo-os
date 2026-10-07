// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import starlightLinksValidator from 'starlight-links-validator';

export default defineConfig({
	site: 'https://docs.nubosuite.tech',
	integrations: [
		starlight({
			plugins: [starlightLinksValidator({ errorOnRelativeLinks: false })],
			title: 'Nubo Docs',
			description: 'Documentation for Nubo OS (the desktop and the server) and Nubo Office.',
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
			sidebar: [
				{ label: 'Nubo OS', items: [
					{ label: 'Start here', items: [{ autogenerate: { directory: 'start' } }] },
					{ label: 'Desktop', items: [
						{ slug: 'desktop' },
						{ label: 'Get started', collapsed: true, items: [{ autogenerate: { directory: 'desktop/get-started' } }] },
						{ label: 'Using the desktop', collapsed: true, items: [{ autogenerate: { directory: 'desktop/use' } }] },
						{ label: 'Nubo account and cloud', collapsed: true, items: [{ autogenerate: { directory: 'desktop/account' } }] },
						{ label: 'Apps', collapsed: true, items: [{ autogenerate: { directory: 'desktop/apps' } }] },
						{ label: 'Settings', collapsed: true, items: [{ autogenerate: { directory: 'desktop/settings' } }] },
						{ label: 'Troubleshooting', collapsed: true, items: [{ autogenerate: { directory: 'desktop/troubleshooting' } }] },
					] },
					{ label: 'Server', items: [
						{ slug: 'server' },
						{ label: 'Install', collapsed: true, items: [{ autogenerate: { directory: 'server/install' } }] },
						{ label: 'Administer', collapsed: true, items: [{ autogenerate: { directory: 'server/administer' } }] },
						{ label: 'Security', collapsed: true, items: [{ autogenerate: { directory: 'server/security' } }] },
						{ label: 'Flavours', collapsed: true, items: [{ autogenerate: { directory: 'server/flavours' } }] },
						{ label: 'Autoinstall', collapsed: true, items: [{ autogenerate: { directory: 'server/autoinstall' } }] },
						{ label: 'Images', collapsed: true, items: [{ autogenerate: { directory: 'server/images' } }] },
					] },
					{ label: 'Updates and the archive', items: [{ autogenerate: { directory: 'updates' } }] },
					{ label: 'Reference', items: [{ autogenerate: { directory: 'reference' } }] },
					{ label: 'Developers', items: [{ autogenerate: { directory: 'developers' } }] },
				] },
				{ label: 'Nubo Office', items: [
					{ slug: 'office' },
					{ label: 'Features', collapsed: true, items: [{ autogenerate: { directory: 'office/features' } }] },
					{ label: 'Installing', collapsed: true, items: [{ autogenerate: { directory: 'office/install' } }] },
					{ label: 'Using Nubo Office', collapsed: true, items: [{ autogenerate: { directory: 'office/use' } }] },
					{ label: 'Accounts and files', collapsed: true, items: [{ autogenerate: { directory: 'office/account' } }] },
					{ label: 'Help', collapsed: true, items: [{ autogenerate: { directory: 'office/help' } }] },
					{ slug: 'office/open-source' },
				] },
			],
		}),
	],
});
