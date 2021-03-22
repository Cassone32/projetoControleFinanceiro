# projetoControleFinanceiro 1.0
Projeto básico utilizando das tecnologias: MariaDB 10 e Lazarus. 

# Para começar:
  1. Execute o script presente em: Script's BD para criar o objeto da base de dados necessário para uso do projeto; 
  2. Através do 'data module' principal (udm), deverá ser alterado o componente 'TZConnection', alterando as propriedades da conexão, endereço da base de dados, usuário e senha (caso houver); e 
  4. Utilizando-se do Lazarus, verifique se você possui os seguintes pacotes (packages) instalados em sua IDE: Pacote Zeos Lib. 

# Principais funcionalidades:
  Por se tratar de uma versão inicial há muitas poucas funcionalidades presentes no projeto, porém, já é possível realizar lançamentos de despesas, vinculando-os aos meses, chamados de 'referência' pela aplicação.
  
  Inicialmente deve-se criar através dos formulários de manutenção, as categorias, status e referências das despesas, para posterior lançamento, vinculando os objetos entre si.
  
# Área técnica (estrutura do projeto)
  1. O projeto possui um Data Module principal, com o componente de conexão, bem como as Query's e Data Sources utilizados pelos formulários (não há eventos nesses componentes);
  2. As principais funcionalidades de manipulação de dados está presente na unidade de funções (uFuncoes.pas), nela há as procedures de inclusão, alteração, busca geral e específica e exclusão. Há ainda functions responsáveis por verificar vínculo de objetos na base de dados;
  3. Todos os formulários possuem Timer's responsáveis por verificar o status da janela e definir o comportamento dos botões de ação; e
  4. Para ações de consulta, utiliza-se dos componentes (Query's) principais, presentes no udm, já para ações de manipulação de dados, utilizo de componentes auxiliares.


  
  
  
  
  
  
 
