package com.tec.logotec.compilador.ast;

public class Not implements ASTNode {

	private ASTNode operand1;
	
	public Not(ASTNode operand1) {
		super();
		this.operand1 = operand1;
	}
	
	@Override
	public Object execute(Context symbolTable) {
		return !(Boolean)operand1.execute(symbolTable);
	}

}
