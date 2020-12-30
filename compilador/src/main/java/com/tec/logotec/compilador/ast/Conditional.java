package com.tec.logotec.compilador.ast;

import java.util.List;
import java.util.Map;

public class Conditional implements ASTNode {

	private ASTNode condition;
	private List<ASTNode> ifBody;
	private List<ASTNode> elseBody;
	
	
	
	public Conditional(ASTNode condition, List<ASTNode> ifBody, List<ASTNode> elseBody) {
		super();
		this.condition = condition;
		this.ifBody = ifBody;
		this.elseBody = elseBody;
	}



	@Override
	public Object execute(Map<String, Object> symbolTable) {
		if((boolean)condition.execute(symbolTable)) {
			for (ASTNode statement : ifBody) {
				statement.execute(symbolTable);
			}
		}else {
			for (ASTNode statement : elseBody) {
				statement.execute(symbolTable);
			}
		}
		return null;
	}

}
