package com.tec.logotec.compilador.ast;

import java.util.List;

public class IfConditional implements ASTNode {

	private ASTNode condition;
	private List<ASTNode> ifBody;
	
	
	public IfConditional(ASTNode condition, List<ASTNode> ifBody) {
		super();
		this.condition = condition;
		this.ifBody = ifBody;
	}

	@Override
	public Object execute(Context symbolTable) {
		if((boolean)condition.execute(symbolTable)) {
			for (ASTNode statement : ifBody) {
				statement.execute(symbolTable);
			}
		}
		return null;
	}

}
