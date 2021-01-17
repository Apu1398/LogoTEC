package com.tec.logotec.compilador.ast;

import java.util.List;

public class Elemento implements ASTNode {

	private List<ASTNode> mathExpressions;
	private ASTNode enesimo;
	

	public Elemento(ASTNode enesimo, List<ASTNode> mathExpressions) {
		super();
		this.mathExpressions = mathExpressions;
		this.enesimo = enesimo;
	}
	
	
	@Override
	public Object execute(Context symbolTable) {
		if(0<=(int)enesimo.execute(symbolTable) && (int)enesimo.execute(symbolTable) < mathExpressions.size() ) {
			return mathExpressions.get((int)enesimo.execute(symbolTable)).execute(symbolTable);
		}else {
			return null;			
		}
	}

}
