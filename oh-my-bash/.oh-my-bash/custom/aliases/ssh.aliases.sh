export USER=samuel

alias br76="ssh br76"

alias dev="ssh samuel@dev.serverdo.in -p 51439"

# Função para exibir ajuda sobre todas as funções neste arquivo.
# Ela extrai descrições dos comentários e parâmetros da mensagem de "Uso" de cada função.
h() {
    # Identifica o próprio arquivo que está sendo executado
    local alias_file=~/.oh-my-bash/custom/aliases/ssh.aliases.sh
    if [ ! -f "$alias_file" ]; then
        echo "Erro: Não foi possível encontrar o arquivo de origem."
        return 1
    fi

    echo -e "\n\e[1;33mAjuda para as funções definidas em: ${alias_file}\e[0m"
    echo "=================================================="

    # Buffer para armazenar os comentários de descrição
    local comment_buffer=()
    # Regex para identificar uma declaração de função (ex: "ss()" ou "function ss()")
    local func_regex="^(function )?([a-zA-Z0-9_]+)\s*\(\)\s*\{"

    # Lê o arquivo linha por linha
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Se a linha é um comentário, armazena seu conteúdo no buffer
        if [[ "$line" =~ ^# ]]; then
            # Remove o '#' e espaços em branco do início do comentário
            comment_buffer+=("$(echo "$line" | sed 's/^# *//')")
        # Se a linha é uma declaração de função e temos comentários no buffer
        elif [[ "$line" =~ $func_regex ]] && [ ${#comment_buffer[@]} -gt 0 ]; then
            local func_name="${BASH_REMATCH[2]}"

            # Ignora a própria função de ajuda para não se auto-documentar
            if [[ "$func_name" == "h" ]]; then
                comment_buffer=()
                continue
            fi

            # Imprime o nome da função em destaque (Ciano, Negrito)
            printf "\n\e[1;36m%s\e[0m\n" "${func_name}"

            # Imprime a descrição a partir do buffer de comentários
            echo -e "  \e[33mDescrição:\e[0m"
            for comment_line in "${comment_buffer[@]}"; do
                printf "    %s\n" "$comment_line"
            done

            # Imprime os parâmetros executando a função-alvo sem argumentos para capturar sua mensagem de "Uso"
            echo -e "  \e[33mParâmetros:\e[0m"
            # Executa a função em um subshell para capturar a saída (stdout e stderr)
            # e evitar efeitos colaterais.
            local usage_output
            usage_output=$( ("$func_name") 2>&1 )
            # Filtra e formata a linha que contém "Uso:"
            echo "$usage_output" | grep --color=never "Uso:" | sed 's/^/    /'

            # Limpa o buffer para a próxima função
            comment_buffer=()
        # Se é uma linha em branco, não faz nada (mantém os comentários no buffer)
        elif [[ -z "$line" ]]; then
            continue
        # Se é qualquer outra linha (código dentro de uma função, etc.), limpa o buffer
        else
            comment_buffer=()
        fi
    done < "$alias_file"

    echo "=================================================="
}

# Função para acessar uma máquina remota via servidor intermediário, com byobu em ambos
function ss() {
    local jump_user="samuel.cavilha"
    local jump_host="br76"
    local target_host="$1"

    if [ -z "$target_host" ]; then
        echo "Uso: ss maquina_destino"
        return 1
    fi

    local session_name=$(echo "$USER" | tr '.' '_')
    ssh -t "${jump_user}@${jump_host}" "sudo ssh -t -p51439 ${target_host} \"byobu new-session -A -s ${session_name}\""
}

# Função para copiar conteúdo de um arquivo remoto para a área de transferência local
function scf() {
    local jump_user="samuel.cavilha"
    local jump_host="br76"
    local target_host="$1"
    local caminho_arquivo="$2"

    if [ -z "$target_host" ] || [ -z "$caminho_arquivo" ]; then
        echo "Uso: scf maquina_destino caminho_completo_do_arquivo"
        return 1
    fi

    ssh -t "${jump_user}@${jump_host}" "sudo ssh -t -p51439 ${target_host} \"cat ${caminho_arquivo}\"" | sed '1,7d' | head -n -1 | xclip -selection clipboard
}

# Função para montar um sistema de arquivos remoto usando SSHFS com sudo no servidor
function sm() {
    # Para depurar, remova o '#' da linha abaixo
    # set -x

    # Pega o argumento obrigatório do endereço primeiro
    local full_address="$1"
    shift # Remove o endereço da lista de argumentos, o que sobrar são as opções

    if [ -z "$full_address" ]; then
        echo "Uso: sm usuario@host:/caminho/remoto [-p PORTA]"
        # set +x
        return 1
    fi

    local port_args="-p 51439" # Variável que guardará os argumentos da porta

    # Loop para processar os argumentos opcionais (como a porta)
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -p|--port)
                # Se encontrar -p ou --port, guarda a flag e o número da porta
                port_args="-p $2"
                shift # Passa pela flag (-p)
                shift # Passa pelo valor (o número da porta)
                ;;
            *)
                # Ignora argumentos desconhecidos
                shift
                ;;
        esac
    done

    # --- O restante da lógica continua igual ---
    local server_part="${full_address%%:*}"
    local hostname="${server_part#*@}"
    local remote_path="${full_address#*:}"
    local last_dir_name
    last_dir_name=$(basename "${remote_path}")
    local transformed_dir_name="${last_dir_name//_/-}"
    local local_dir_name="${hostname}--${transformed_dir_name}"
    local local_mount_point="$HOME/remote_server/${local_dir_name}"

    echo ">> Verificando e criando ponto de montagem: ${local_mount_point}"
    mkdir -p "${local_mount_point}"

    echo ">> Montando ${full_address} em ${local_mount_point} (Porta: ${port_args#-p })"
    #
    # LINHA ALTERADA ABAIXO
    # A variável $port_args é adicionada ao comando.
    # Se nenhuma porta for passada, a variável estará vazia e não afetará o comando.
    #
    sshfs ${port_args} "${full_address}" "${local_mount_point}" \
        -o sftp_server="sudo /usr/lib/openssh/sftp-server" \
        -o PreferredAuthentications=password

    # Para depurar, remova o '#' da linha abaixo
    # set +x
}

# Função para desmontar um sistema de arquivos montado com fusermount
function umount() {
    local path="$1"

    if [ -z "$path" ]; then
        echo "Uso: umount caminho_local_montado"
        return 1
    fi

    fusermount -u "${path}"
}


