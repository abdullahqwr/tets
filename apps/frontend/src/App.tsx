import { useQuery } from '@tanstack/react-query';
import axios from 'axios';
import './app.css';

type ApiHealth = {
  status: string;
  version: string;
  timestamp: string;
};

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? '/api';

async function fetchHealth(): Promise<ApiHealth> {
  const { data } = await axios.get<ApiHealth>(`${API_BASE_URL}/health`);
  return data;
}

export function App() {
  const { data, isLoading, error } = useQuery({ queryKey: ['health'], queryFn: fetchHealth });

  return (
    <main className="container">
      <header>
        <h1>Azure Cloud-Native Web App</h1>
        <p>Welcome to the re-architected experience on AKS.</p>
      </header>
      <section>
        <h2>Backend Health</h2>
        {isLoading && <p>Loading...</p>}
        {error && <p className="error">Failed to load health check.</p>}
        {data && (
          <ul>
            <li>Status: {data.status}</li>
            <li>Version: {data.version}</li>
            <li>Timestamp: {data.timestamp}</li>
          </ul>
        )}
      </section>
    </main>
  );
}

export default App;
