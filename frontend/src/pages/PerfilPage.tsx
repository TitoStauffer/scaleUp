import { useState, type ChangeEvent, type FormEvent } from 'react';
import {
  atualizarPerfil,
  fetchEstatisticasPerfil,
  fetchFotoPerfilUrl,
  fetchUsuarioAtual,
  removerFotoPerfil,
  uploadFotoPerfil,
} from '../api/usuarios';
import { ApiError } from '../api/client';
import { useAsync } from '../hooks/useAsync';
import { RequestState } from '../components/RequestState';
import type { EstatisticasPerfil, UsuarioAtual } from '../api/types';

const TAMANHO_MAXIMO_BYTES = 2 * 1024 * 1024;
const TIPOS_ACEITOS = ['image/jpeg', 'image/png', 'image/webp'];

interface DadosPerfil {
  usuario: UsuarioAtual;
  estatisticas: EstatisticasPerfil;
  fotoUrl: string | null;
}

async function carregarPerfil(): Promise<DadosPerfil> {
  const [usuario, estatisticas, fotoUrl] = await Promise.all([
    fetchUsuarioAtual(),
    fetchEstatisticasPerfil(),
    fetchFotoPerfilUrl(),
  ]);
  return { usuario, estatisticas, fotoUrl };
}

function formatarPontuacao(valor: number | null): string {
  return valor === null ? 'Ainda sem dados suficientes' : valor.toFixed(2);
}

/**
 * Perfil do usuário logado (TICKET-perfil-usuario.md): dados pessoais (nome, nascimento,
 * e-mail somente leitura, foto) + estatísticas de uso consolidadas (geral e por domínio).
 */
export function PerfilPage() {
  const result = useAsync(carregarPerfil, []);

  return (
    <RequestState result={result} loadingLabel="Carregando perfil...">
      {(dados) => <PerfilConteudo dados={dados} onRecarregar={result.reload} />}
    </RequestState>
  );
}

type EstadoFormulario =
  | { status: 'idle' }
  | { status: 'salvando' }
  | { status: 'sucesso' }
  | { status: 'erro'; mensagem: string };

type EstadoFoto =
  | { status: 'idle' }
  | { status: 'enviando' }
  | { status: 'erro'; mensagem: string };

function PerfilConteudo({ dados, onRecarregar }: { dados: DadosPerfil; onRecarregar: () => void }) {
  const [nome, setNome] = useState(dados.usuario.nome ?? '');
  const [dataNascimento, setDataNascimento] = useState(dados.usuario.dataNascimento ?? '');
  const [estadoFormulario, setEstadoFormulario] = useState<EstadoFormulario>({ status: 'idle' });
  const [estadoFoto, setEstadoFoto] = useState<EstadoFoto>({ status: 'idle' });

  const salvando = estadoFormulario.status === 'salvando';
  const enviandoFoto = estadoFoto.status === 'enviando';

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setEstadoFormulario({ status: 'salvando' });
    try {
      await atualizarPerfil({ nome: nome.trim() === '' ? null : nome.trim(), dataNascimento: dataNascimento || null });
      setEstadoFormulario({ status: 'sucesso' });
    } catch (err) {
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado. Tente novamente.';
      setEstadoFormulario({ status: 'erro', mensagem });
    }
  }

  async function handleUploadFoto(event: ChangeEvent<HTMLInputElement>) {
    const arquivo = event.target.files?.[0];
    event.target.value = '';
    if (!arquivo) return;

    if (!TIPOS_ACEITOS.includes(arquivo.type)) {
      setEstadoFoto({ status: 'erro', mensagem: 'Tipo de arquivo não suportado. Use JPEG, PNG ou WebP.' });
      return;
    }
    if (arquivo.size > TAMANHO_MAXIMO_BYTES) {
      setEstadoFoto({ status: 'erro', mensagem: 'Arquivo maior que o limite de 2MB.' });
      return;
    }

    setEstadoFoto({ status: 'enviando' });
    try {
      await uploadFotoPerfil(arquivo);
      onRecarregar();
    } catch (err) {
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado ao enviar a foto.';
      setEstadoFoto({ status: 'erro', mensagem });
    }
  }

  async function handleRemoverFoto() {
    setEstadoFoto({ status: 'enviando' });
    try {
      await removerFotoPerfil();
      onRecarregar();
    } catch (err) {
      const mensagem =
        err instanceof ApiError ? err.message : 'Ocorreu um erro inesperado ao remover a foto.';
      setEstadoFoto({ status: 'erro', mensagem });
    }
  }

  return (
    <section aria-labelledby="perfil-title" className="perfil-page">
      <h1 id="perfil-title">Meu perfil</h1>

      <h2>Dados pessoais</h2>

      <div className="perfil-foto">
        {dados.fotoUrl ? (
          <img src={dados.fotoUrl} alt="Foto de perfil" className="perfil-foto-preview" />
        ) : (
          <div className="perfil-foto-preview perfil-foto-preview--vazia" aria-hidden="true" />
        )}
        <div className="perfil-foto-acoes">
          <label className="perfil-foto-upload">
            {enviandoFoto ? 'Enviando...' : 'Enviar foto'}
            <input
              type="file"
              accept={TIPOS_ACEITOS.join(',')}
              disabled={enviandoFoto}
              onChange={handleUploadFoto}
              className="visually-hidden"
            />
          </label>
          {dados.fotoUrl && (
            <button type="button" onClick={handleRemoverFoto} disabled={enviandoFoto}>
              Remover foto
            </button>
          )}
        </div>
        {estadoFoto.status === 'erro' && (
          <p role="alert" className="auth-field-error">
            {estadoFoto.mensagem}
          </p>
        )}
      </div>

      <form className="auth-form" onSubmit={handleSubmit} noValidate>
        <label className="auth-field">
          <span>Nome</span>
          <input
            type="text"
            name="nome"
            maxLength={120}
            value={nome}
            disabled={salvando}
            onChange={(e) => setNome(e.target.value)}
          />
        </label>

        <label className="auth-field">
          <span>Data de nascimento</span>
          <input
            type="date"
            name="dataNascimento"
            max={new Date().toISOString().slice(0, 10)}
            value={dataNascimento}
            disabled={salvando}
            onChange={(e) => setDataNascimento(e.target.value)}
          />
        </label>

        <label className="auth-field">
          <span>E-mail</span>
          <input type="email" value={dados.usuario.email} disabled readOnly />
        </label>

        {estadoFormulario.status === 'sucesso' && (
          <p role="status" className="status-message">
            Perfil atualizado com sucesso.
          </p>
        )}
        {estadoFormulario.status === 'erro' && (
          <div role="alert" className="status-message status-message--error">
            <p>{estadoFormulario.mensagem}</p>
          </div>
        )}

        <button type="submit" disabled={salvando}>
          {salvando ? 'Salvando...' : 'Salvar dados pessoais'}
        </button>
      </form>

      <h2>Estatísticas de uso</h2>

      <div className="perfil-estatisticas-geral">
        <p>Sessões de estudo (todas): {dados.estatisticas.geral.totalSessoesEstudo}</p>
        <p>Tentativas de quiz concluídas (todas): {dados.estatisticas.geral.totalTentativasQuiz}</p>
        <p>
          Pontuação geral média:{' '}
          {dados.estatisticas.geral.resultadoGeralAvaliado
            ? formatarPontuacao(dados.estatisticas.geral.pontuacaoGeralMedia)
            : 'Ainda não avaliado'}
        </p>
      </div>

      <table className="perfil-estatisticas-tabela">
        <thead>
          <tr>
            <th>Domínio</th>
            <th>Sessões de estudo</th>
            <th>Tentativas de quiz</th>
            <th>Pontuação média de quiz</th>
          </tr>
        </thead>
        <tbody>
          {dados.estatisticas.porDominio.map((item) => (
            <tr key={item.domainRef}>
              <td>{item.nomeDominio}</td>
              <td>{item.totalSessoesEstudo}</td>
              <td>{item.totalTentativasQuiz}</td>
              <td>{formatarPontuacao(item.pontuacaoQuizMedia)}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
