package com.tec.logotec.compilador.ast;


import java.lang.Math;

public class Redondea implements ASTNode {

	private ASTNode expression;
	
	
	public Redondea(ASTNode expression) {
		super();
		this.expression = expression;
		
	}
	
	@Override
	public Object execute(Context symbolTable) {
		return Math.round((int)expression.execute(symbolTable));
	}

}
