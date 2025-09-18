import 'package:mobile_sales/database/database_services.dart';
import 'package:mobile_sales/model/produto.dart';

class ProdutoController {
  Future<List<Produto>> getProdutos(String pesquisa, {int tabela = 0}) async {
    final db = await DatabaseService().database;
    late String macroPesquisa;

    final pesquisaId = double.tryParse(pesquisa);

    if (pesquisaId != null) {
      macroPesquisa = 'AND PROD_ID = ?2';
    } else {
      macroPesquisa = 'AND UPPER(PROD_DESCRICAO) LIKE UPPER(?2)';
    }

    final res = await db.rawQuery('''
      SELECT PROD_ID, PROD_DESCRICAO, PROD_PRECO*(1+COALESCE(TB_PERCENT, 0)/100) PROD_PRECO, PROD_CBARRA, PROD_GRUPO, PROD_SUBGRUPO,
        PROD_MARCA, PROD_BONIFICA, PROD_IMG, PROD_COR, PROD_DEVOLVE, PROD_ATIVO, PROD_DESCRICAOTEC, 
        PROD_EMBALAGEM, PROD_SALDO, PROD_PBONIFICACAO, PROD_CORTE, PROD_PMIN, PROD_LIMDESC
      FROM PRODUTOS LEFT JOIN TABELA_PRECO ON
        TB_PROD=PROD_ID AND TB_ID = ?1
      WHERE PROD_ID>0 AND PROD_ATIVO = 'S' $macroPesquisa
    ''', [
      tabela,
      pesquisaId != null ? pesquisa : '%${pesquisa.replaceAll(' ', '%')}%'
    ]);

    return res.map((e) => Produto.fromMap(e)).toList();
  }

  Future<Produto?> getProdutoById(int id) async {
    final db = await DatabaseService().database;

    final res = await db.query(
      'PRODUTOS',
      where: 'PROD_ID = ?',
      whereArgs: [id],
    );

    if (res.length == 1) {
      return Produto.fromMap(res[0]);
    } else {
      return null;
    }
  }
}
