import { describe, expect, it } from 'vitest';
import { render, screen } from '@testing-library/react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import App from './App';

function renderWithProvider() {
  const queryClient = new QueryClient();
  return render(
    <QueryClientProvider client={queryClient}>
      <App />
    </QueryClientProvider>
  );
}

describe('App', () => {
  it('renders header text', () => {
    renderWithProvider();
    expect(screen.getByText(/Azure Cloud-Native Web App/i)).toBeInTheDocument();
  });
});
