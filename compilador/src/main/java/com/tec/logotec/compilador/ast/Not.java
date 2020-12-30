package com.tec.logotec.compilador.ast;

import java.util.Map;

public class Not implements ASTNode {

	private ASTNode operand1;
	
	public Not(ASTNode operand1) {
		super();
		this.operand1 = operand1;
	}
	
	@Override
	public Object execute(Map<String, Object> symbolTable) {
		return !(Boolean)operand1.execute(symbolTable);
	}

}
