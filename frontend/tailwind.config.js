/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Brand Primary - Azul Premium
        'primary-brand': '#3B82F6',
        'primary-50': '#EFF6FF',
        'primary-100': '#DBEAFE',
        'primary-200': '#BFDBFE',
        'primary-300': '#93C5FD',
        'primary-400': '#60A5FA',
        'primary-500': '#3B82F6',
        'primary-600': '#2563EB',
        'primary-700': '#1D4ED8',
        'primary-800': '#1E40AF',
        'primary-900': '#1E3A8A',

        // Secundario - Púrpura
        'secondary': {
          50: '#F3E8FF',
          100: '#E9D5FF',
          200: '#D8B4FE',
          300: '#C084FC',
          400: '#A855F7',
          500: '#9333EA',
          600: '#7E22CE',
          700: '#6B21A8',
          800: '#581C87',
          900: '#3F0F5C',
        },

        // Éxito - Verde Profesional
        'success': '#10B981',
        'success-50': '#ECFDF5',
        'success-100': '#D1FAE5',
        'success-200': '#A7F3D0',
        'success-300': '#6EE7B7',
        'success-400': '#34D399',
        'success-500': '#10B981',
        'success-600': '#059669',
        'success-700': '#047857',
        'success-800': '#065F46',
        'success-900': '#064E3B',

        // Advertencia - Ámbar
        'warning': '#F59E0B',
        'warning-50': '#FFFBEB',
        'warning-100': '#FEF3C7',
        'warning-200': '#FDE68A',
        'warning-300': '#FCD34D',
        'warning-400': '#FBBF24',
        'warning-500': '#F59E0B',
        'warning-600': '#D97706',
        'warning-700': '#B45309',
        'warning-800': '#92400E',
        'warning-900': '#78350F',

        // Peligro - Rojo
        'danger': '#EF4444',
        'danger-50': '#FEF2F2',
        'danger-100': '#FEE2E2',
        'danger-200': '#FECACA',
        'danger-300': '#FCA5A5',
        'danger-400': '#F87171',
        'danger-500': '#EF4444',
        'danger-600': '#DC2626',
        'danger-700': '#B91C1C',
        'danger-800': '#991B1B',
        'danger-900': '#7F1D1D',

        // Información - Cyan
        'info': '#06B6D4',
        'info-50': '#ECFDFD',
        'info-100': '#CFFAFE',
        'info-200': '#A5F3FC',
        'info-300': '#67E8F9',
        'info-400': '#22D3EE',
        'info-500': '#06B6D4',
        'info-600': '#0891B2',
        'info-700': '#0E7490',
        'info-800': '#155E75',
        'info-900': '#164E63',

        // Neutro - Grises Premium
        'neutral': {
          50: '#F9FAFB',
          100: '#F3F4F6',
          200: '#E5E7EB',
          300: '#D1D5DB',
          400: '#9CA3AF',
          500: '#6B7280',
          600: '#4B5563',
          700: '#374151',
          800: '#1F2937',
          900: '#111827',
          950: '#030712',
        }
      },
      
      fontFamily: {
        'sans': ['Inter', 'Segoe UI', 'Roboto', 'sans-serif'],
        'display': ['Poppins', 'sans-serif'],
      },

      fontSize: {
        'xs': ['0.75rem', { lineHeight: '1rem' }],
        'sm': ['0.875rem', { lineHeight: '1.25rem' }],
        'base': ['1rem', { lineHeight: '1.5rem' }],
        'lg': ['1.125rem', { lineHeight: '1.75rem' }],
        'xl': ['1.25rem', { lineHeight: '1.75rem' }],
        '2xl': ['1.5rem', { lineHeight: '2rem' }],
        '3xl': ['1.875rem', { lineHeight: '2.25rem' }],
        '4xl': ['2.25rem', { lineHeight: '2.5rem' }],
        '5xl': ['3rem', { lineHeight: '1' }],
      },

      boxShadow: {
        'xs': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        'sm': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        'base': '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06)',
        'md': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
        'lg': '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)',
        'xl': '0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)',
        '2xl': '0 25px 50px -12px rgba(0, 0, 0, 0.25)',
        'premium': '0 20px 40px rgba(59, 130, 246, 0.15)',
        'premium-lg': '0 30px 60px rgba(59, 130, 246, 0.2)',
      },

      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'gradient-conic': 'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
        'gradient-premium': 'linear-gradient(135deg, #3B82F6 0%, #9333EA 100%)',
      },

      animation: {
        'pulse-subtle': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'float': 'float 6s ease-in-out infinite',
        'slide-in': 'slideIn 0.5s ease-out',
      },

      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        slideIn: {
          '0%': { transform: 'translateX(-100%)', opacity: '0' },
          '100%': { transform: 'translateX(0)', opacity: '1' },
        }
      }
    },
  },
  plugins: [
  ],
}