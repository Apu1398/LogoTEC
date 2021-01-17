package com.tec.logotec.compilador.ast;

import java.util.List;

public class Cuenta implements ASTNode {

	private List<ASTNode> mathExpressions;
	

	public Cuenta(List<ASTNode> mathExpressions) {
		super();
		this.mathExpressions = mathExpressions;
	}

	
	@Override
	public Object execute(Context symbolTable) {
		
		return (int)mathExpressions.size();
	}

}
