package com.tec.logotec.compilador.ast;

public class Menos implements ASTNode {

	private ASTNode expression;
	
	
	
	
	public Menos(ASTNode expression) {
		super();
		this.expression = expression;
	}




	@Override
	public Object execute(Context symbolTable) {
		
		return -(int)expression.execute(symbolTable);
	}

}
